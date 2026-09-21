const homeService = require('./home.service');
const ApiResponse = require('../../utils/ApiResponse');
const asyncHandler = require('../../utils/asyncHandler');

const getHome = asyncHandler(async (req, res) => {
  const home = await homeService.getHome(req.user, req.query.tab);
  return ApiResponse.success(res, 'Home data fetched successfully', home);
});

module.exports = { getHome };
