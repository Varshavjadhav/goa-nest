const exploreService = require('./explore.service');
const ApiResponse = require('../../utils/ApiResponse');
const asyncHandler = require('../../utils/asyncHandler');

const getExplore = asyncHandler(async (req, res) => {
  const explore = await exploreService.getExplore(req.user, req.query.tab);
  return ApiResponse.success(res, 'Explore data fetched successfully', explore);
});

module.exports = { getExplore };
