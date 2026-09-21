const Booking = require('./booking.model');
const Property = require('../property/property.model');
const ApiError = require('../../utils/ApiError');
const { MESSAGES, BOOKING_STATUS } = require('../../config/constants');

const createBooking = async (guestId, data) => {
  const { property: propertyId, checkIn, checkOut, guests, specialRequests } = data;

  const property = await Property.findById(propertyId);
  if (!property) {
    throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
  }

  const checkInDate = new Date(checkIn);
  const checkOutDate = new Date(checkOut);

  if (checkOutDate <= checkInDate) {
    throw ApiError.badRequest(MESSAGES.CHECK_OUT_AFTER_CHECK_IN);
  }

  const nights = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24));
  if (nights < property.minimumNights) {
    throw ApiError.badRequest(`Minimum stay is ${property.minimumNights} night(s)`);
  }
  if (nights > property.maximumNights) {
    throw ApiError.badRequest(`Maximum stay is ${property.maximumNights} night(s)`);
  }

  const totalGuests = (guests.adults || 1) + (guests.children || 0);
  if (totalGuests > property.maxGuests) {
    throw ApiError.badRequest(`Maximum ${property.maxGuests} guests allowed`);
  }

  const overlapping = await Booking.countDocuments({
    property: propertyId,
    status: { $in: [BOOKING_STATUS.PENDING, BOOKING_STATUS.CONFIRMED] },
    checkIn: { $lt: checkOutDate },
    checkOut: { $gt: checkInDate },
  });

  if (overlapping > 0) {
    throw ApiError.badRequest(MESSAGES.PROPERTY_NOT_AVAILABLE);
  }

  const pricePerNight = property.pricePerNight;
  const totalPrice = nights * pricePerNight;
  const cleaningFee = Math.round(pricePerNight * 0.05);
  const serviceFee = Math.round(totalPrice * 0.14);

  const booking = await Booking.create({
    property: propertyId,
    guest: guestId,
    checkIn: checkInDate,
    checkOut: checkOutDate,
    guests: {
      adults: guests.adults || 1,
      children: guests.children || 0,
      infants: guests.infants || 0,
    },
    nights,
    pricePerNight,
    totalPrice,
    cleaningFee,
    serviceFee,
    specialRequests,
    status: BOOKING_STATUS.CONFIRMED,
  });

  await Property.findByIdAndUpdate(propertyId, { $inc: { totalBookings: 1 } });

  return booking.populate([
    { path: 'property', select: 'title images location' },
    { path: 'guest', select: 'name email avatar' },
  ]);
};

const getBookingsByGuest = async (guestId, status, page = 1, limit = 20) => {
  const skip = (page - 1) * limit;
  const query = { guest: guestId };
  if (status) query.status = status;

  const [bookings, total] = await Promise.all([
    Booking.find(query)
      .populate('property', 'title images location pricePerNight')
      .populate('guest', 'name email avatar')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit),
    Booking.countDocuments(query),
  ]);

  return { bookings, total, page, pages: Math.ceil(total / limit) };
};

const getBookingsByProperty = async (propertyId, hostId) => {
  const property = await Property.findOne({ _id: propertyId, host: hostId });
  if (!property) {
    throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
  }

  const bookings = await Booking.find({ property: propertyId })
    .populate('guest', 'name email avatar')
    .sort({ createdAt: -1 });

  return bookings;
};

const getBookingById = async (bookingId, userId) => {
  const booking = await Booking.findById(bookingId)
    .populate('property', 'title images location pricePerNight host')
    .populate('guest', 'name email avatar');

  if (!booking) {
    throw ApiError.notFound(MESSAGES.BOOKING_NOT_FOUND);
  }

  const isGuest = booking.guest._id.toString() === userId;
  const isHost = booking.property.host.toString() === userId;

  if (!isGuest && !isHost) {
    throw ApiError.forbidden(MESSAGES.FORBIDDEN);
  }

  return booking;
};

const cancelBooking = async (bookingId, userId, reason) => {
  const booking = await Booking.findById(bookingId)
    .populate('property', 'host');

  if (!booking) {
    throw ApiError.notFound(MESSAGES.BOOKING_NOT_FOUND);
  }

  if (booking.guest.toString() !== userId && booking.property.host.toString() !== userId) {
    throw ApiError.forbidden(MESSAGES.FORBIDDEN);
  }

  if (booking.status === BOOKING_STATUS.CANCELLED || booking.status === BOOKING_STATUS.COMPLETED) {
    throw ApiError.badRequest(`Cannot cancel a ${booking.status} booking`);
  }

  booking.status = BOOKING_STATUS.CANCELLED;
  booking.cancellationReason = reason || 'Cancelled by user';
  await booking.save();

  return booking;
};

module.exports = {
  createBooking,
  getBookingsByGuest,
  getBookingsByProperty,
  getBookingById,
  cancelBooking,
};
