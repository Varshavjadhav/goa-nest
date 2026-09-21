const authService = require('./auth.service');
const ApiResponse = require('../../utils/ApiResponse');
const { MESSAGES } = require('../../config/constants');
const asyncHandler = require('../../utils/asyncHandler');

const register = asyncHandler(async (req, res) => {
  const { user, accessToken, refreshToken } = await authService.register(req.body);
  return ApiResponse.success(
    res,
    MESSAGES.REGISTER_SUCCESS,
    { user, accessToken, refreshToken },
    201
  );
});

const login = asyncHandler(async (req, res) => {
  const { user, accessToken, refreshToken } = await authService.login(req.body);
  return ApiResponse.success(res, MESSAGES.LOGIN_SUCCESS, {
    user,
    accessToken,
    refreshToken,
  });
});

const refreshToken = asyncHandler(async (req, res) => {
  const { accessToken, refreshToken: newRefreshToken } =
    await authService.refreshAccessToken(req.body.refreshToken);
  return ApiResponse.success(res, MESSAGES.TOKEN_REFRESHED, {
    accessToken,
    refreshToken: newRefreshToken,
  });
});

const logout = asyncHandler(async (req, res) => {
  await authService.logout(req.user);
  return ApiResponse.success(res, MESSAGES.LOGOUT_SUCCESS);
});

module.exports = { register, login, refreshToken, logout };
