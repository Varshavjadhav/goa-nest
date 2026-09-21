const bookingService = require('./booking.service');
const ApiResponse = require('../../utils/ApiResponse');
const { MESSAGES } = require('../../config/constants');
const asyncHandler = require('../../utils/asyncHandler');

const createBooking = asyncHandler(async (req, res) => {
  const booking = await bookingService.createBooking(req.user, req.body);
  return ApiResponse.success(res, MESSAGES.BOOKING_CREATED, { booking }, 201);
});

const getMyBookings = asyncHandler(async (req, res) => {
  const { status, page, limit } = req.query;
  const result = await bookingService.getBookingsByGuest(req.user, status, page, limit);
  return ApiResponse.success(res, MESSAGES.BOOKINGS_FETCHED, result);
});

const getBooking = asyncHandler(async (req, res) => {
  const booking = await bookingService.getBookingById(req.params.id, req.user);
  return ApiResponse.success(res, MESSAGES.BOOKING_FETCHED, { booking });
});

const cancelBooking = asyncHandler(async (req, res) => {
  const { reason } = req.body;
  const booking = await bookingService.cancelBooking(req.params.id, req.user, reason);
  return ApiResponse.success(res, MESSAGES.BOOKING_CANCELLED, { booking });
});

const getPropertyBookings = asyncHandler(async (req, res) => {
  const bookings = await bookingService.getBookingsByProperty(req.params.propertyId, req.user);
  return ApiResponse.success(res, MESSAGES.BOOKINGS_FETCHED, { bookings });
});

module.exports = {
  createBooking,
  getMyBookings,
  getBooking,
  cancelBooking,
  getPropertyBookings,
};
