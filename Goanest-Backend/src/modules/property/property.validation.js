const Joi = require('joi');
const { PROPERTY_TYPE } = require('../../config/constants');

const createProperty = Joi.object({
  title: Joi.string().max(100).required().messages({
    'any.required': 'Title is required',
    'string.max': 'Title cannot exceed 100 characters',
  }),
  description: Joi.string().max(2000).required().messages({
    'any.required': 'Description is required',
    'string.max': 'Description cannot exceed 2000 characters',
  }),
  propertyType: Joi.string()
    .valid(...Object.values(PROPERTY_TYPE))
    .required()
    .messages({
      'any.required': 'Property type is required',
      'any.only': 'Invalid property type',
    }),
  category: Joi.string().allow(null, ''),
  location: Joi.object({
    address: Joi.string().required().messages({ 'any.required': 'Address is required' }),
    city: Joi.string().required().messages({ 'any.required': 'City is required' }),
    state: Joi.string().allow(null, ''),
    country: Joi.string().required().messages({ 'any.required': 'Country is required' }),
    zipCode: Joi.string().allow(null, ''),
    lat: Joi.number().min(-90).max(90),
    lng: Joi.number().min(-180).max(180),
  }).required(),
  pricePerNight: Joi.number().min(0).required().messages({
    'any.required': 'Price per night is required',
    'number.min': 'Price must be a positive number',
  }),
  maxGuests: Joi.number().min(1).required().messages({
    'any.required': 'Maximum guests is required',
    'number.min': 'At least 1 guest is required',
  }),
  bedrooms: Joi.number().min(0).required().messages({
    'any.required': 'Number of bedrooms is required',
  }),
  beds: Joi.number().min(0).required().messages({
    'any.required': 'Number of beds is required',
  }),
  bathrooms: Joi.number().min(0).required().messages({
    'any.required': 'Number of bathrooms is required',
  }),
  amenities: Joi.array().items(Joi.string()).default([]),
  images: Joi.array().items(
    Joi.object({
      url: Joi.string().uri().required(),
      caption: Joi.string().allow(null, ''),
      isPrimary: Joi.boolean().default(false),
    })
  ).default([]),
  houseRules: Joi.string().max(1000).allow(null, ''),
  checkInTime: Joi.string().default('15:00'),
  checkOutTime: Joi.string().default('11:00'),
  minimumNights: Joi.number().min(1).default(1),
  maximumNights: Joi.number().min(1).default(365),
  bookingType: Joi.string().valid('instant', 'request').default('instant'),
});

const updateProperty = Joi.object({
  title: Joi.string().max(100),
  description: Joi.string().max(2000),
  propertyType: Joi.string().valid(...Object.values(PROPERTY_TYPE)),
  category: Joi.string().allow(null, ''),
  location: Joi.object({
    address: Joi.string(),
    city: Joi.string(),
    state: Joi.string().allow(null, ''),
    country: Joi.string(),
    zipCode: Joi.string().allow(null, ''),
    lat: Joi.number().min(-90).max(90),
    lng: Joi.number().min(-180).max(180),
  }),
  pricePerNight: Joi.number().min(0),
  maxGuests: Joi.number().min(1),
  bedrooms: Joi.number().min(0),
  beds: Joi.number().min(0),
  bathrooms: Joi.number().min(0),
  amenities: Joi.array().items(Joi.string()),
  images: Joi.array().items(
    Joi.object({
      url: Joi.string().uri().required(),
      caption: Joi.string().allow(null, ''),
      isPrimary: Joi.boolean(),
    })
  ),
  houseRules: Joi.string().max(1000).allow(null, ''),
  checkInTime: Joi.string(),
  checkOutTime: Joi.string(),
  minimumNights: Joi.number().min(1),
  maximumNights: Joi.number().min(1),
  bookingType: Joi.string().valid('instant', 'request'),
  isActive: Joi.boolean(),
});

module.exports = { createProperty, updateProperty };
