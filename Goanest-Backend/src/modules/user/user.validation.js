const Joi = require('joi');

const phone = Joi.string()
  .trim()
  .min(7)
  .max(20)
  .pattern(/^\+?[0-9\s().-]+$/)
  .messages({
    'string.min': 'Phone number must be at least 7 characters',
    'string.max': 'Phone number cannot exceed 20 characters',
    'string.pattern.base': 'Please provide a valid phone number',
  });

const updateProfile = Joi.object({
  name: Joi.string().min(2).max(50),
  phone,
  bio: Joi.string().max(500).allow('', null),
  avatar: Joi.string().allow('', null),
  location: Joi.string().allow('', null),
  dateOfBirth: Joi.date().allow(null),
  language: Joi.string(),
  currency: Joi.string(),
}).min(1);

module.exports = { updateProfile };
