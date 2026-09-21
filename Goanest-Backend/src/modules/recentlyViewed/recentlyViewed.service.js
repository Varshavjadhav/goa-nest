const mongoose = require('mongoose');
const RecentlyViewed = require('./recentlyViewed.model');
const Property = require('../property/property.model');
const favoriteService = require('../favorite/favorite.service');
const ApiError = require('../../utils/ApiError');
const { MESSAGES } = require('../../config/constants');

const populateOptions = [
  { path: 'host', select: 'name avatar' },
  { path: 'category', select: 'name slug icon' },
];

const markViewed = async (userId, propertyId) => {
  if (!mongoose.isValidObjectId(propertyId)) throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
  const property = await Property.findOne({ _id: propertyId, isActive: true }).select('_id');
  if (!property) throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
  await RecentlyViewed.findOneAndUpdate(
    { user: userId, property: propertyId },
    { $set: { viewedAt: new Date() } },
    { upsert: true, new: true, setDefaultsOnInsert: true }
  );
  return { propertyId, viewedAt: new Date() };
};

const getRecentlyViewed = async (userId, page = 1, limit = 20) => {
  page = Math.max(Number(page) || 1, 1);
  limit = Math.min(Math.max(Number(limit) || 20, 1), 100);
  const skip = (page - 1) * limit;
  const [records, total] = await Promise.all([
    RecentlyViewed.find({ user: userId }).sort({ viewedAt: -1 }).skip(skip).limit(limit).populate({ path: 'property', match: { isActive: true }, populate: populateOptions }).lean(),
    RecentlyViewed.countDocuments({ user: userId }),
  ]);
  const recordsWithProperties = records.filter((record) => record.property);
  const likedIds = await favoriteService.getFavoritePropertyIds(userId, recordsWithProperties.map((record) => record.property._id));
  const properties = recordsWithProperties.map((record) => ({ ...record.property, viewedAt: record.viewedAt, isLiked: likedIds.has(record.property._id.toString()) }));
  return { properties, total, page, limit, pages: Math.ceil(total / limit) };
};

module.exports = { markViewed, getRecentlyViewed };
