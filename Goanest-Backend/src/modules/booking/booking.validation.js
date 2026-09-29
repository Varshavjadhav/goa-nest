const Joi = require('joi');

const createBooking = Joi.object({
  property: Joi.string().required().messages({
    'any.required': 'Property ID is required',
  }),
  checkIn: Joi.date().iso().required().messages({
    'any.required': 'Check-in date is required',
    'date.base': 'Invalid check-in date',
  }),
  checkOut: Joi.date().iso().greater(Joi.ref('checkIn')).required().messages({
    'any.required': 'Check-out date is required',
    'date.greater': 'Check-out must be after check-in',
  }),
  guests: Joi.object({
    adults: Joi.number().min(1).default(1),
    children: Joi.number().min(0).default(0),
    infants: Joi.number().min(0).default(0),
  }).default({ adults: 1, children: 0, infants: 0 }),
  rooms: Joi.number().integer().min(1).default(1),
  specialRequests: Joi.string().max(500).allow(null, ''),
});

const cancelBooking = Joi.object({
  reason: Joi.string().max(500).allow(null, ''),
});

module.exports = { createBooking, cancelBooking };
