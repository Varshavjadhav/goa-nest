const userService = require('./user.service');
const ApiResponse = require('../../utils/ApiResponse');
const { MESSAGES } = require('../../config/constants');
const asyncHandler = require('../../utils/asyncHandler');

const getProfile = asyncHandler(async (req, res) => {
  const user = await userService.getProfile(req.user);
  return ApiResponse.success(res, MESSAGES.PROFILE_FETCHED, { user });
});

const updateProfile = asyncHandler(async (req, res) => {
  const user = await userService.updateProfile(req.user, req.body);
  return ApiResponse.success(res, MESSAGES.PROFILE_UPDATED, { user });
});

module.exports = { getProfile, updateProfile };
