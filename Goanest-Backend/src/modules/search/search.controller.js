const searchService = require('./search.service');
const ApiResponse = require('../../utils/ApiResponse');
const asyncHandler = require('../../utils/asyncHandler');

const search = asyncHandler(async (req, res) => {
  const result = await searchService.search(req.query, req.user);
  return ApiResponse.success(res, 'Search results fetched successfully', result);
});

const getSuggestions = asyncHandler(async (req, res) => {
  const suggestions = await searchService.getSuggestions(req.query.q);
  return ApiResponse.success(res, 'Suggestions fetched successfully', { suggestions });
});

module.exports = { search, getSuggestions };
