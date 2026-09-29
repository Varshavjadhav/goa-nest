const Joi = require('joi');

const name = Joi.string().trim().min(1).max(50).required().messages({
  'string.empty': 'Wishlist name is required',
  'string.min': 'Wishlist name is required',
  'string.max': 'Wishlist name cannot exceed 50 characters',
  'any.required': 'Wishlist name is required',
});

module.exports = {
  createWishlist: Joi.object({ name }),
  updateWishlist: Joi.object({ name }),
};
