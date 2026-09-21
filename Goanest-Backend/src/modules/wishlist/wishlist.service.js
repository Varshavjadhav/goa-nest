const Wishlist = require('./wishlist.model');
const ApiError = require('../../utils/ApiError');
const { MESSAGES } = require('../../config/constants');

const getWishlists = async (userId) => {
  const wishlists = await Wishlist.find({ user: userId })
    .populate('properties.property', 'title images pricePerNight location averageRating')
    .sort({ createdAt: -1 });
  return wishlists;
};

const createWishlist = async (userId, name) => {
  const wishlist = await Wishlist.create({ user: userId, name });
  return wishlist;
};

const updateWishlist = async (wishlistId, userId, name) => {
  const wishlist = await Wishlist.findOneAndUpdate(
    { _id: wishlistId, user: userId },
    { name },
    { new: true }
  );
  if (!wishlist) {
    throw ApiError.notFound(MESSAGES.WISHLIST_NOT_FOUND);
  }
  return wishlist;
};

const deleteWishlist = async (wishlistId, userId) => {
  const wishlist = await Wishlist.findOneAndDelete({ _id: wishlistId, user: userId });
  if (!wishlist) {
    throw ApiError.notFound(MESSAGES.WISHLIST_NOT_FOUND);
  }
  return true;
};

const addProperty = async (wishlistId, userId, propertyId) => {
  const wishlist = await Wishlist.findOne({ _id: wishlistId, user: userId });
  if (!wishlist) {
    throw ApiError.notFound(MESSAGES.WISHLIST_NOT_FOUND);
  }

  const alreadyExists = wishlist.properties.some(
    (p) => p.property.toString() === propertyId
  );
  if (alreadyExists) {
    throw ApiError.badRequest(MESSAGES.ALREADY_IN_WISHLIST);
  }

  wishlist.properties.push({ property: propertyId });
  await wishlist.save();

  return wishlist.populate('properties.property', 'title images pricePerNight location averageRating');
};

const removeProperty = async (wishlistId, userId, propertyId) => {
  const wishlist = await Wishlist.findOne({ _id: wishlistId, user: userId });
  if (!wishlist) {
    throw ApiError.notFound(MESSAGES.WISHLIST_NOT_FOUND);
  }

  wishlist.properties = wishlist.properties.filter(
    (p) => p.property.toString() !== propertyId
  );
  await wishlist.save();

  return wishlist.populate('properties.property', 'title images pricePerNight location averageRating');
};

module.exports = {
  getWishlists,
  createWishlist,
  updateWishlist,
  deleteWishlist,
  addProperty,
  removeProperty,
};
