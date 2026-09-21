const wishlistService = require('./wishlist.service');
const ApiResponse = require('../../utils/ApiResponse');
const { MESSAGES } = require('../../config/constants');
const asyncHandler = require('../../utils/asyncHandler');

const getWishlists = asyncHandler(async (req, res) => {
  const wishlists = await wishlistService.getWishlists(req.user);
  return ApiResponse.success(res, MESSAGES.WISHLISTS_FETCHED, { wishlists });
});

const createWishlist = asyncHandler(async (req, res) => {
  const wishlist = await wishlistService.createWishlist(req.user, req.body.name);
  return ApiResponse.success(res, MESSAGES.WISHLIST_CREATED, { wishlist }, 201);
});

const updateWishlist = asyncHandler(async (req, res) => {
  const wishlist = await wishlistService.updateWishlist(req.params.id, req.user, req.body.name);
  return ApiResponse.success(res, MESSAGES.WISHLIST_UPDATED, { wishlist });
});

const deleteWishlist = asyncHandler(async (req, res) => {
  await wishlistService.deleteWishlist(req.params.id, req.user);
  return ApiResponse.success(res, MESSAGES.WISHLIST_DELETED);
});

const addProperty = asyncHandler(async (req, res) => {
  const wishlist = await wishlistService.addProperty(req.params.id, req.user, req.params.propertyId);
  return ApiResponse.success(res, MESSAGES.PROPERTY_ADDED_TO_WISHLIST, { wishlist });
});

const removeProperty = asyncHandler(async (req, res) => {
  const wishlist = await wishlistService.removeProperty(req.params.id, req.user, req.params.propertyId);
  return ApiResponse.success(res, MESSAGES.PROPERTY_REMOVED_FROM_WISHLIST, { wishlist });
});

module.exports = {
  getWishlists,
  createWishlist,
  updateWishlist,
  deleteWishlist,
  addProperty,
  removeProperty,
};
