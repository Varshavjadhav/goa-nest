const User = require('../user/user.model');
const ApiError = require('../../utils/ApiError');
const {
  generateAccessToken,
  generateRefreshToken,
  verifyRefreshToken,
} = require('../../utils/tokenUtils');
const { MESSAGES } = require('../../config/constants');

const register = async ({ name, email, phone, password }) => {
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    throw ApiError.conflict(MESSAGES.USER_ALREADY_EXISTS);
  }

  const user = await User.create({ name, email, phone, password });

  const accessToken = generateAccessToken(user._id, user.role);
  const refreshToken = generateRefreshToken(user._id);

  user.refreshToken = refreshToken;
  await user.save();

  return { user, accessToken, refreshToken };
};

const login = async ({ email, password }) => {
  const user = await User.findOne({ email }).select('+password');
  if (!user || !user.isActive) {
    throw ApiError.unauthorized(MESSAGES.INVALID_CREDENTIALS);
  }

  const isPasswordValid = await user.comparePassword(password);
  if (!isPasswordValid) {
    throw ApiError.unauthorized(MESSAGES.INVALID_CREDENTIALS);
  }

  const accessToken = generateAccessToken(user._id, user.role);
  const refreshToken = generateRefreshToken(user._id);

  user.refreshToken = refreshToken;
  await user.save();

  return { user, accessToken, refreshToken };
};

const refreshAccessToken = async (token) => {
  const decoded = verifyRefreshToken(token);

  const user = await User.findById(decoded.userId).select('+refreshToken');
  if (!user || !user.isActive || user.refreshToken !== token) {
    throw ApiError.unauthorized(MESSAGES.INVALID_TOKEN);
  }

  const accessToken = generateAccessToken(user._id, user.role);
  const newRefreshToken = generateRefreshToken(user._id);

  user.refreshToken = newRefreshToken;
  await user.save();

  return { accessToken, refreshToken: newRefreshToken };
};

const logout = async (userId) => {
  const user = await User.findById(userId);
  if (user) {
    user.refreshToken = null;
    await user.save();
  }
  return true;
};

module.exports = { register, login, refreshAccessToken, logout };
