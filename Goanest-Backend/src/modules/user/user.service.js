const User = require('./user.model');
const ApiError = require('../../utils/ApiError');
const { MESSAGES } = require('../../config/constants');

const getProfile = async (userId) => {
  const user = await User.findById(userId);
  if (!user) {
    throw ApiError.notFound(MESSAGES.USER_NOT_FOUND);
  }
  return user;
};

const updateProfile = async (userId, updateData) => {
  const allowedFields = ['name', 'phone', 'bio', 'avatar', 'location', 'dateOfBirth', 'language', 'currency'];
  const updates = {};

  for (const field of allowedFields) {
    if (updateData[field] !== undefined) {
      updates[field] = updateData[field];
    }
  }

  const user = await User.findByIdAndUpdate(userId, updates, {
    new: true,
    runValidators: true,
  });

  if (!user) {
    throw ApiError.notFound(MESSAGES.USER_NOT_FOUND);
  }

  return user;
};

module.exports = { getProfile, updateProfile };
