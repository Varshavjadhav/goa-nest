const recentlyViewedService = require('./recentlyViewed.service');
const ApiResponse = require('../../utils/ApiResponse');
const asyncHandler = require('../../utils/asyncHandler');

const markViewed = asyncHandler(async (req, res) => {
  const result = await recentlyViewedService.markViewed(req.user, req.params.propertyId);
  return ApiResponse.success(res, 'Property view recorded successfully', result);
});

const getRecentlyViewed = asyncHandler(async (req, res) => {
  const result = await recentlyViewedService.getRecentlyViewed(req.user, req.query.page, req.query.limit);
  return ApiResponse.success(res, 'Recently viewed properties fetched successfully', result);
});

module.exports = { markViewed, getRecentlyViewed };
