const mongoose = require('mongoose');

const reviewSchema = new mongoose.Schema(
  {
    property: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Property',
      required: [true, 'Property is required'],
    },
    guest: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Guest is required'],
    },
    booking: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Booking',
      required: [true, 'Booking is required'],
    },
    rating: {
      type: Number,
      required: [true, 'Rating is required'],
      min: 1,
      max: 5,
    },
    comment: {
      type: String,
      maxlength: 1000,
      default: null,
    },
    cleanliness: { type: Number, min: 1, max: 5, default: null },
    accuracy: { type: Number, min: 1, max: 5, default: null },
    communication: { type: Number, min: 1, max: 5, default: null },
    location: { type: Number, min: 1, max: 5, default: null },
    checkIn: { type: Number, min: 1, max: 5, default: null },
    value: { type: Number, min: 1, max: 5, default: null },
  },
  { timestamps: true }
);

reviewSchema.index({ property: 1, guest: 1 }, { unique: true });
reviewSchema.index({ property: 1, createdAt: -1 });

module.exports = mongoose.model('Review', reviewSchema);
