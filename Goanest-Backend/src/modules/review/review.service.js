const Review = require('./review.model');
const Booking = require('../booking/booking.model');
const Property = require('../property/property.model');
const ApiError = require('../../utils/ApiError');
const { MESSAGES, BOOKING_STATUS } = require('../../config/constants');

const createReview = async (guestId, propertyId, bookingId, data) => {
  const existingReview = await Review.findOne({ booking: bookingId, guest: guestId });
  if (existingReview) {
    throw ApiError.badRequest(MESSAGES.ALREADY_REVIEWED);
  }

  const booking = await Booking.findOne({
    _id: bookingId,
    guest: guestId,
    property: propertyId,
    status: BOOKING_STATUS.COMPLETED,
  });

  if (!booking) {
    throw ApiError.badRequest(MESSAGES.CANNOT_REVIEW_UNBOOKED);
  }

  const review = await Review.create({
    property: propertyId,
    guest: guestId,
    booking: bookingId,
    ...data,
  });

  const stats = await Review.aggregate([
    { $match: { property: review.property } },
    {
      $group: {
        _id: null,
        avgRating: { $avg: '$rating' },
        totalReviews: { $sum: 1 },
      },
    },
  ]);

  if (stats.length > 0) {
    await Property.findByIdAndUpdate(propertyId, {
      averageRating: Math.round(stats[0].avgRating * 10) / 10,
      totalReviews: stats[0].totalReviews,
    });
  }

  return review.populate('guest', 'name avatar');
};

const getReviewsByProperty = async (propertyId, page = 1, limit = 10) => {
  const skip = (page - 1) * limit;
  const [reviews, total] = await Promise.all([
    Review.find({ property: propertyId })
      .populate('guest', 'name avatar')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit),
    Review.countDocuments({ property: propertyId }),
  ]);

  return { reviews, total, page, pages: Math.ceil(total / limit) };
};

module.exports = { createReview, getReviewsByProperty };
