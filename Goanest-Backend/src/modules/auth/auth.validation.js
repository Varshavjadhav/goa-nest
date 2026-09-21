const Joi = require('joi');

const register = Joi.object({
  name: Joi.string().min(2).max(50).required().messages({
    'any.required': 'Name is required',
    'string.min': 'Name must be at least 2 characters',
    'string.max': 'Name cannot exceed 50 characters',
  }),
  email: Joi.string().email().required().messages({
    'any.required': 'Email is required',
    'string.email': 'Please provide a valid email',
  }),
  phone: Joi.string()
    .trim()
    .min(7)
    .max(20)
    .pattern(/^\+?[0-9\s().-]+$/)
    .required()
    .messages({
      'any.required': 'Phone number is required',
      'string.empty': 'Phone number is required',
      'string.min': 'Phone number must be at least 7 characters',
      'string.max': 'Phone number cannot exceed 20 characters',
      'string.pattern.base': 'Please provide a valid phone number',
    }),
  password: Joi.string().min(6).required().messages({
    'any.required': 'Password is required',
    'string.min': 'Password must be at least 6 characters',
  }),
});

const login = Joi.object({
  email: Joi.string().email().required().messages({
    'any.required': 'Email is required',
    'string.email': 'Please provide a valid email',
  }),
  password: Joi.string().required().messages({
    'any.required': 'Password is required',
  }),
});

const refreshToken = Joi.object({
  refreshToken: Joi.string().required().messages({
    'any.required': 'Refresh token is required',
  }),
});

module.exports = { register, login, refreshToken };
