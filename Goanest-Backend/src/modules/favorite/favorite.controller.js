const favoriteService = require('./favorite.service');
const ApiResponse = require('../../utils/ApiResponse');
const asyncHandler = require('../../utils/asyncHandler');

const likeProperty = asyncHandler(async (req, res) => {
  const result = await favoriteService.setFavorite(req.user, req.params.propertyId, true);
  return ApiResponse.success(res, 'Property liked successfully', result);
});

const unlikeProperty = asyncHandler(async (req, res) => {
  const result = await favoriteService.setFavorite(req.user, req.params.propertyId, false);
  return ApiResponse.success(res, 'Property unliked successfully', result);
});

module.exports = { likeProperty, unlikeProperty };
