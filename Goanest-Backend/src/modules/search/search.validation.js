const Joi = require('joi');
const mongoose = require('mongoose');
const { PROPERTY_TYPE } = require('../../config/constants');

const optionalNumber = (minimum, maximum = Number.MAX_SAFE_INTEGER) =>
  Joi.alternatives().try(
    Joi.number().min(minimum).max(maximum),
    Joi.string().valid(''),
  ).messages({
    'alternatives.types': '{{#label}} must be a valid number',
    'alternatives.match': 'Search filters must contain valid numeric values',
    'number.min': 'A search filter value is below its allowed minimum',
    'number.max': 'A search filter value is above its allowed maximum',
  });

const search = Joi.object({
  query: Joi.string().trim().max(100).allow(''),
  city: Joi.string().trim().max(100).allow(''),
  country: Joi.string().trim().max(100).allow(''),
  propertyType: Joi.string()
    .trim()
    .max(100)
    .allow('')
    .custom((value, helpers) => {
      if (!value) return value;
      const supported = new Set(Object.values(PROPERTY_TYPE));
      const types = value.split(',').map((item) => item.trim());
      if (types.some((type) => !supported.has(type))) {
        return helpers.error('any.invalid');
      }
      return value;
    })
    .messages({ 'any.invalid': 'One or more property types are not supported' }),
  category: Joi.string()
    .allow('')
    .custom((value, helpers) =>
      !value || mongoose.isValidObjectId(value)
        ? value
        : helpers.error('any.invalid'),
    )
    .messages({ 'any.invalid': 'category must be a valid category ID' }),
  tab: Joi.string()
    .valid('all', 'homes', 'villas', 'beach', 'experiences', 'services')
    .allow(''),
  minPrice: optionalNumber(0),
  maxPrice: optionalNumber(0),
  maxGuests: optionalNumber(1),
  infants: optionalNumber(0),
  pets: optionalNumber(0),
  bedrooms: optionalNumber(0),
  beds: optionalNumber(0),
  bathrooms: optionalNumber(0),
  amenities: Joi.string().trim().max(500).allow(''),
  minRating: optionalNumber(0, 5),
  checkIn: Joi.string().isoDate().allow(''),
  checkOut: Joi.string().isoDate().allow(''),
  flexible: Joi.boolean().truthy('true').falsy('false'),
  flexibleDuration: Joi.string().valid('', 'week', 'weekend', 'month'),
  flexibleMonth: Joi.string().pattern(/^\d{4}-(0[1-9]|1[0-2])$/).allow(''),
  flexibilityDays: optionalNumber(0, 3),
  sortBy: Joi.string()
    .valid('', 'price_asc', 'price_desc', 'rating', 'newest'),
  page: Joi.number().integer().min(1),
  limit: Joi.number().integer().min(1).max(100),
})
  .custom((value, helpers) => {
    const min = value.minPrice === '' ? null : Number(value.minPrice);
    const max = value.maxPrice === '' ? null : Number(value.maxPrice);
    if (min != null && max != null && min > max) {
      return helpers.error('any.invalid', { message: 'minPrice cannot exceed maxPrice' });
    }
    const checkIn = value.checkIn || '';
    const checkOut = value.checkOut || '';
    if (Boolean(checkIn) !== Boolean(checkOut)) {
      return helpers.error('any.invalid', { message: 'Both checkIn and checkOut are required' });
    }
    if (checkIn && checkOut && new Date(checkOut) <= new Date(checkIn)) {
      return helpers.error('any.invalid', { message: 'checkOut must be after checkIn' });
    }
    if (value.flexibleMonth && !value.flexible) {
      return helpers.error('any.invalid', { message: 'flexible must be true with flexibleMonth' });
    }
    if (value.flexibleMonth && !value.flexibleDuration) {
      return helpers.error('any.invalid', { message: 'flexibleDuration is required with flexibleMonth' });
    }
    return value;
  })
  .messages({
    'any.invalid': 'Check price order, date order, and flexible date options.',
  });

const suggestions = Joi.object({
  q: Joi.string().trim().max(100).allow(''),
});

module.exports = { search, suggestions };
