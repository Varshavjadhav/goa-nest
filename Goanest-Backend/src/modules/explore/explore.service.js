const Property = require('../property/property.model');
const Category = require('../category/category.model');
const RecentlyViewed = require('../recentlyViewed/recentlyViewed.model');
const favoriteService = require('../favorite/favorite.service');

const propertyPopulate = [
  { path: 'host', select: 'name avatar' },
  { path: 'category', select: 'name slug icon' },
];

const HOME_TABS = [
  { key: 'all', label: 'All', icon: '✦' },
  { key: 'homes', label: 'Homes', icon: 'home' },
  { key: 'villas', label: 'Villas', icon: 'home' },
  { key: 'beach', label: 'Beach', icon: 'beach' },
  { key: 'experiences', label: 'Experiences', icon: 'camera' },
  { key: 'services', label: 'Services', icon: 'settings' },
];

const toCard = (property, isLiked = false, extra = {}) => ({
  id: property._id,
  title: property.title,
  imageUrl: property.images?.find((image) => image.isPrimary)?.url || property.images?.[0]?.url || null,
  images: property.images || [],
  propertyType: property.propertyType,
  location: {
    city: property.location?.city || null,
    state: property.location?.state || null,
    country: property.location?.country || null,
    lat: property.location?.lat || null,
    lng: property.location?.lng || null,
    label: [property.location?.city, property.location?.state || property.location?.country].filter(Boolean).join(', '),
  },
  rating: property.averageRating || 0,
  reviewCount: property.totalReviews || 0,
  pricePerNight: property.pricePerNight,
  currency: 'INR',
  isLiked,
  ...extra,
});

const mapProperties = async (properties, userId) => {
  const plainProperties = properties.map((property) => (property.toObject ? property.toObject() : property));
  const propertyIds = plainProperties.map((property) => property._id);
  const likedIds = await getLikedPropertyIds(userId, propertyIds);
  return plainProperties.map((property) => toCard(property, likedIds.has(property._id.toString())));
};

const getLikedPropertyIds = async (userId, propertyIds) => {
  if (!userId || !propertyIds.length) return new Set();

  return favoriteService.getFavoritePropertyIds(userId, propertyIds);
};

const getRecentRecords = async (userId) => {
  if (!userId) return [];
  return RecentlyViewed.find({ user: userId })
    .sort({ viewedAt: -1 })
    .limit(4)
    .populate({ path: 'property', match: { isActive: true }, populate: propertyPopulate })
    .lean();
};

const getTripInspiration = async () => Property.aggregate([
  { $match: { isActive: true } },
  { $sort: { totalBookings: -1, averageRating: -1 } },
  { $group: {
    _id: { city: '$location.city', country: '$location.country' },
    imageUrl: { $first: { $arrayElemAt: ['$images.url', 0] } },
    propertyCount: { $sum: 1 },
  } },
  { $sort: { propertyCount: -1, '_id.city': 1 } },
  { $limit: 6 },
  { $project: {
    _id: 0,
    city: '$_id.city',
    country: '$_id.country',
    title: '$_id.city',
    subtitle: { $concat: ['Explore stays in ', '$_id.city'] },
    imageUrl: 1,
    propertyCount: 1,
  } },
]);

const getPropertyFilter = async (tab = 'all') => {
  const normalizedTab = String(tab || 'all').toLowerCase();
  const filter = { isActive: true };

  if (normalizedTab === 'villas') {
    filter.propertyType = 'villa';
  } else if (normalizedTab === 'homes') {
    filter.propertyType = { $in: ['apartment', 'house', 'villa', 'cottage', 'cabin', 'treehouse', 'castle', 'tent', 'other'] };
  } else if (normalizedTab === 'beach') {
    const beachCategory = await Category.findOne({ slug: 'beachfront', isActive: true }).select('_id').lean();
    filter.$or = [
      ...(beachCategory ? [{ category: beachCategory._id }] : []),
      { amenities: { $in: ['Beach access', 'Beachfront', 'Beach'] } },
    ];
  }

  return { normalizedTab, filter };
};

const getExplore = async (userId, tab = 'all') => {
  const { normalizedTab, filter } = await getPropertyFilter(tab);
  const propertyTab = normalizedTab === 'experiences' || normalizedTab === 'services';
  const propertyQuery = propertyTab ? { isActive: true, _id: { $exists: false } } : filter;
  const recentRecords = await getRecentRecords(userId);
  const recentPropertyIds = recentRecords.filter((record) => record.property).map((record) => record.property._id);

  const [allProperties, tripInspiration] = await Promise.all([
    Property.find(propertyQuery).populate(propertyPopulate).lean(),
    getTripInspiration(),
  ]);

  // Keep home sections distinct. With a small inventory, independent top-N
  // queries made the same listings appear in every carousel.
  const usedPropertyIds = new Set(
    normalizedTab === 'all' ? recentPropertyIds.map((id) => id.toString()) : [],
  );
  const takeUnique = (properties, sort, limit = 6) => {
    const selected = [];
    for (const property of [...properties].sort(sort)) {
      const id = property._id.toString();
      if (usedPropertyIds.has(id)) continue;
      usedPropertyIds.add(id);
      selected.push(property);
      if (selected.length === limit) break;
    }
    return selected;
  };
  const recommended = takeUnique(
    allProperties,
    (a, b) => b.averageRating - a.averageRating || b.totalReviews - a.totalReviews || b.createdAt - a.createdAt,
  );
  const popularDestinationStays = takeUnique(
    allProperties,
    (a, b) => b.totalBookings - a.totalBookings || b.averageRating - a.averageRating,
  );
  const guestFavourites = takeUnique(
    allProperties,
    (a, b) => b.averageRating - a.averageRating || b.totalReviews - a.totalReviews,
  );

  const recentLikedIds = await getLikedPropertyIds(userId, recentPropertyIds);
  const recentItems = normalizedTab === 'all'
    ? recentRecords
    .filter((record) => record.property)
    .map((record) => toCard(record.property, recentLikedIds.has(record.property._id.toString()), { viewedAt: record.viewedAt }))
    : [];

  const lastViewed = recentItems[0];

  return {
    search: {
      placeholder: 'Start your search',
      filtersAvailable: true,
      queryEndpoint: '/api/v1/search',
    },
    tabs: HOME_TABS.map((item) => ({ ...item, active: item.key === normalizedTab })),
    continueSearching: lastViewed
      ? {
        visible: true,
        title: `Continue searching for homes in ${lastViewed.location.city || lastViewed.location.country}`,
        subtitle: 'Continue exploring stays',
        imageUrl: lastViewed.imageUrl,
        propertyId: lastViewed.id,
      }
      : { visible: false, title: null, subtitle: null, imageUrl: null, propertyId: null },
    recentlyViewed: {
      items: recentItems,
      total: recentItems.length,
      limit: 4,
      seeAll: { enabled: Boolean(userId && recentItems.length), endpoint: '/api/v1/recently-viewed' },
    },
    recommendedForYou: {
      items: await mapProperties(recommended, userId),
      total: recommended.length,
    },
    popularDestinationStays: {
      items: await mapProperties(popularDestinationStays, userId),
      total: popularDestinationStays.length,
    },
    guestFavourites: {
      title: 'Based on your recent searches',
      items: await mapProperties(guestFavourites, userId),
      total: guestFavourites.length,
    },
    tripInspiration,
    experiences: {
      title: normalizedTab === 'services' ? 'Goanest Services' : 'Airbnb Experiences',
      subtitle: normalizedTab === 'services'
        ? 'Helpful services for a comfortable stay'
        : 'Unforgettable activities hosted by locals',
      ctaLabel: normalizedTab === 'services' ? 'Show all services' : 'Show all experiences',
      enabled: normalizedTab === 'experiences' || normalizedTab === 'services',
      message: normalizedTab === 'services'
        ? 'Local services will be available soon.'
        : 'Experiences will be available soon.',
    },
  };
};

module.exports = { getExplore, toCard };
