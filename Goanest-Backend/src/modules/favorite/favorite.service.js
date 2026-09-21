const mongoose = require('mongoose');
const Favorite = require('./favorite.model');
const Property = require('../property/property.model');
const ApiError = require('../../utils/ApiError');
const { MESSAGES } = require('../../config/constants');

const assertProperty = async (propertyId) => {
  if (!mongoose.isValidObjectId(propertyId)) throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
  const property = await Property.findOne({ _id: propertyId, isActive: true }).select('_id');
  if (!property) throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
};

const setFavorite = async (userId, propertyId, liked) => {
  await assertProperty(propertyId);
  if (liked) {
    await Favorite.updateOne({ user: userId, property: propertyId }, { $setOnInsert: { user: userId, property: propertyId } }, { upsert: true });
  } else {
    await Favorite.deleteOne({ user: userId, property: propertyId });
  }
  return { propertyId, isLiked: liked };
};

const getFavoritePropertyIds = async (userId, propertyIds) => {
  if (!userId || !propertyIds.length) return new Set();
  const favorites = await Favorite.find({ user: userId, property: { $in: propertyIds } }).select('property').lean();
  return new Set(favorites.map((favorite) => favorite.property.toString()));
};

module.exports = { setFavorite, getFavoritePropertyIds };
