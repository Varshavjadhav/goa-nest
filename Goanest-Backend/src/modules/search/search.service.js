const Property = require('../property/property.model');
const Category = require('../category/category.model');
const { toCard } = require('../explore/explore.service');
const favoriteService = require('../favorite/favorite.service');

const search = async (filters = {}, userId) => {
  const page = Math.max(Number(filters.page) || 1, 1);
  const limit = Math.min(Math.max(Number(filters.limit) || 20, 1), 100);
  const skip = (page - 1) * limit;

  const query = { isActive: true };

  const escapeRegex = (value) => String(value).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  if (filters.query) {
    const queryText = escapeRegex(filters.query);
    query.$or = [
      { title: new RegExp(queryText, 'i') },
      { description: new RegExp(queryText, 'i') },
      { 'location.city': new RegExp(queryText, 'i') },
      { 'location.state': new RegExp(queryText, 'i') },
      { 'location.country': new RegExp(queryText, 'i') },
      { 'location.address': new RegExp(queryText, 'i') },
    ];
  }

  if (filters.city) query['location.city'] = new RegExp(escapeRegex(filters.city), 'i');
  if (filters.country) query['location.country'] = new RegExp(escapeRegex(filters.country), 'i');
  const selectedTypes = filters.propertyType
    ? String(filters.propertyType).split(',').map((value) => value.trim()).filter(Boolean)
    : null;
  const tabTypes = filters.tab === 'villas'
    ? ['villa']
    : filters.tab === 'homes'
    ? ['apartment', 'house', 'hotel', 'villa', 'cottage', 'cabin', 'treehouse', 'castle', 'tent', 'other']
    : null;
  const propertyTypes = tabTypes && selectedTypes
    ? tabTypes.filter((type) => selectedTypes.includes(type))
    : tabTypes || selectedTypes;
  if (propertyTypes) {
    if (!propertyTypes.length) query._id = { $in: [] };
    else query.propertyType = propertyTypes.length === 1 ? propertyTypes[0] : { $in: propertyTypes };
  }
  if (filters.category) query.category = filters.category;

  if (filters.minPrice || filters.maxPrice) {
    query.pricePerNight = {};
    if (filters.minPrice) query.pricePerNight.$gte = Number(filters.minPrice);
    if (filters.maxPrice) query.pricePerNight.$lte = Number(filters.maxPrice);
  }

  if (filters.maxGuests) query.maxGuests = { $gte: Number(filters.maxGuests) };
  if (filters.bedrooms) query.bedrooms = { $gte: Number(filters.bedrooms) };
  if (filters.beds) query.beds = { $gte: Number(filters.beds) };
  if (filters.bathrooms) query.bathrooms = { $gte: Number(filters.bathrooms) };

  if (filters.amenities) {
    const amenityList = String(filters.amenities).split(',').map((value) => value.trim()).filter(Boolean);
    query.amenities = { $all: amenityList };
  }

  if (filters.minRating) {
    query.averageRating = { $gte: Number(filters.minRating) };
  }

  if (filters.tab === 'beach') {
    const beachCategory = await Category.findOne({ slug: 'beachfront', isActive: true }).select('_id').lean();
    const beachFilters = [
      ...(beachCategory ? [{ category: beachCategory._id }] : []),
      { amenities: { $in: ['Beach access', 'Beachfront', 'Beach'] } },
    ];
    if (query.$or) {
      query.$and = [{ $or: query.$or }, { $or: beachFilters }];
      delete query.$or;
    } else {
      query.$or = beachFilters;
    }
  }
  if (filters.tab === 'experiences' || filters.tab === 'services') {
    return { items: [], properties: [], total: 0, page, limit, pages: 0, pagination: { page, limit, total: 0, pages: 0 } };
  }

  const dateCandidates = getDateCandidates(filters);
  const unavailableForDates = new Set();
  if (dateCandidates.length) {
    const Booking = require('../booking/booking.model');
    const earliestStart = new Date(Math.min(...dateCandidates.map(({ start }) => start.getTime())));
    const latestCheckout = new Date(Math.max(...dateCandidates.map(({ end }) => end.getTime())));
    const bookings = await Booking.find({
      status: { $in: ['pending', 'confirmed'] },
      checkIn: { $lt: latestCheckout },
      checkOut: { $gt: earliestStart },
    }).select('property checkIn checkOut').lean();

    const propertyBookings = new Map();
    for (const booking of bookings) {
      const propertyId = booking.property.toString();
      propertyBookings.set(propertyId, [
        ...(propertyBookings.get(propertyId) || []),
        booking,
      ]);
    }
    for (const [propertyId, propertyRecords] of propertyBookings.entries()) {
      if (dateCandidates.every(({ start, end }) =>
        propertyRecords.some((booking) => booking.checkIn < end && booking.checkOut > start),
      )) unavailableForDates.add(propertyId);
    }
  }

  let sortOption = {};
  switch (filters.sortBy) {
    case 'price_asc':
      sortOption = { pricePerNight: 1 };
      break;
    case 'price_desc':
      sortOption = { pricePerNight: -1 };
      break;
    case 'rating':
      sortOption = { averageRating: -1 };
      break;
    case 'newest':
      sortOption = { createdAt: -1 };
      break;
    default:
      sortOption = { isFeatured: -1, averageRating: -1 };
  }

  const [properties, total] = await Promise.all([
    Property.find(query)
      .populate('host', 'name avatar')
      .populate('category', 'name slug icon')
      .sort(sortOption)
      .skip(skip)
      .limit(Number(limit)),
    Property.countDocuments(query),
  ]);

  const likedIds = await favoriteService.getFavoritePropertyIds(userId, properties.map((property) => property._id));
  const items = properties.map((property) => {
    const plain = property.toObject();
    const isAvailable = !unavailableForDates.has(property._id.toString());
    return toCard(plain, likedIds.has(property._id.toString()), {
      isAvailable,
      availabilityMessage: isAvailable ? 'Available for selected dates' : 'Not available for selected dates',
    });
  });

  return {
    items,
    properties: items,
    total,
    page,
    limit,
    pages: Math.ceil(total / limit),
    pagination: {
      page,
      limit,
      total,
      pages: Math.ceil(total / limit),
    },
  };
};

const getSuggestions = async (query) => {
  const normalizedQuery = String(query || '').trim();
  if (normalizedQuery.length < 2) return [];
  const escapedQuery = normalizedQuery.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

  const suggestions = await Property.aggregate([
    {
      $match: {
        isActive: true,
        $or: [
          { 'location.city': new RegExp(escapedQuery, 'i') },
          { 'location.country': new RegExp(escapedQuery, 'i') },
          { title: new RegExp(escapedQuery, 'i') },
        ],
      },
    },
    {
      $group: {
        _id: '$location.city',
        country: { $first: '$location.country' },
        count: { $sum: 1 },
      },
    },
    { $sort: { count: -1 } },
    { $limit: 5 },
  ]);

  return suggestions.map((s) => ({
    city: s._id,
    country: s.country,
    propertyCount: s.count,
  }));
};

const getDateCandidates = (filters) => {
  const candidates = [];
  const shift = (value, days) => {
    const result = new Date(value);
    result.setUTCDate(result.getUTCDate() + days);
    return result;
  };
  const today = new Date();
  today.setUTCHours(0, 0, 0, 0);
  const flexible = filters.flexible === true || filters.flexible === 'true';

  if (filters.checkIn && filters.checkOut) {
    const flexibility = Number(filters.flexibilityDays) || 0;
    for (let offset = -flexibility; offset <= flexibility; offset++) {
      const start = shift(new Date(filters.checkIn), offset);
      const end = shift(new Date(filters.checkOut), offset);
      if (start >= today) candidates.push({ start, end });
    }
    return candidates;
  }

  if (flexible && filters.flexibleMonth && filters.flexibleDuration) {
    const [year, month] = filters.flexibleMonth.split('-').map(Number);
    const monthStart = new Date(Date.UTC(year, month - 1, 1));
    const monthEnd = new Date(Date.UTC(year, month, 1));
    const duration = filters.flexibleDuration === 'weekend'
      ? 2
      : filters.flexibleDuration === 'month'
      ? 28
      : 7;
    let start = monthStart < today ? today : monthStart;
    while (start < monthEnd) {
      candidates.push({ start: new Date(start), end: shift(start, duration) });
      start = shift(start, 1);
    }
  }
  return candidates;
};

module.exports = { search, getSuggestions };
