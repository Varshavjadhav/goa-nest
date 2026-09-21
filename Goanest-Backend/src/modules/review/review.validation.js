const Joi = require('joi');

const createReview = Joi.object({
  booking: Joi.string().required().messages({
    'any.required': 'Booking ID is required',
  }),
  rating: Joi.number().min(1).max(5).required().messages({
    'any.required': 'Rating is required',
    'number.min': 'Rating must be between 1 and 5',
    'number.max': 'Rating must be between 1 and 5',
  }),
  comment: Joi.string().max(1000).allow(null, ''),
  cleanliness: Joi.number().min(1).max(5),
  accuracy: Joi.number().min(1).max(5),
  communication: Joi.number().min(1).max(5),
  location: Joi.number().min(1).max(5),
  checkIn: Joi.number().min(1).max(5),
  value: Joi.number().min(1).max(5),
});

module.exports = { createReview };
