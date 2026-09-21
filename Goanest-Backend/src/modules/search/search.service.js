const Property = require('../property/property.model');
const Category = require('../category/category.model');
const ApiError = require('../../utils/ApiError');
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
      { 'location.country': new RegExp(queryText, 'i') },
      { 'location.address': new RegExp(queryText, 'i') },
    ];
  }

  if (filters.city) query['location.city'] = new RegExp(escapeRegex(filters.city), 'i');
  if (filters.country) query['location.country'] = new RegExp(escapeRegex(filters.country), 'i');
  if (filters.propertyType) {
    const values = String(filters.propertyType).split(',').map((value) => value.trim()).filter(Boolean);
    query.propertyType = values.length > 1 ? { $in: values } : values[0];
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

  if (filters.checkIn && filters.checkOut) {
    const Booking = require('../booking/booking.model');
    const bookedPropertyIds = await Booking.distinct('property', {
      status: { $in: ['pending', 'confirmed'] },
      checkIn: { $lt: new Date(filters.checkOut) },
      checkOut: { $gt: new Date(filters.checkIn) },
    });
    query._id = { $nin: bookedPropertyIds };
  }

  if (filters.tab === 'villas') query.propertyType = 'villa';
  if (filters.tab === 'homes') {
    query.propertyType = { $in: ['apartment', 'house', 'villa', 'cottage', 'cabin', 'treehouse', 'castle', 'tent', 'other'] };
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
    return toCard(plain, likedIds.has(property._id.toString()));
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
  if (!query || query.length < 2) return [];

  const suggestions = await Property.aggregate([
    {
      $match: {
        isActive: true,
        $or: [
          { 'location.city': new RegExp(query, 'i') },
          { 'location.country': new RegExp(query, 'i') },
          { title: new RegExp(query, 'i') },
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

module.exports = { search, getSuggestions };
