const mongoose = require('mongoose');
const Favorite = require('./favorite.model');
const Wishlist = require('../wishlist/wishlist.model');
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
  const [favorites, wishlists] = await Promise.all([
    Favorite.find({ user: userId, property: { $in: propertyIds } }).select('property').lean(),
    Wishlist.find({ user: userId, 'properties.property': { $in: propertyIds } })
      .select('properties.property')
      .lean(),
  ]);
  const ids = new Set(favorites.map((favorite) => favorite.property.toString()));
  wishlists.forEach((wishlist) => wishlist.properties.forEach(({ property }) => {
    if (property && propertyIds.some((id) => id.toString() === property.toString())) {
      ids.add(property.toString());
    }
  }));
  return ids;
};

module.exports = { setFavorite, getFavoritePropertyIds };
