const mongoose = require('mongoose');
const { PROPERTY_TYPE } = require('../../config/constants');

const propertySchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, 'Title is required'],
      trim: true,
      maxlength: 100,
    },
    description: {
      type: String,
      required: [true, 'Description is required'],
      maxlength: 2000,
    },
    propertyType: {
      type: String,
      enum: Object.values(PROPERTY_TYPE),
      required: [true, 'Property type is required'],
    },
    host: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: [true, 'Host is required'],
    },
    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Category',
      default: null,
    },
    location: {
      address: { type: String, required: [true, 'Address is required'] },
      city: { type: String, required: [true, 'City is required'] },
      state: { type: String, default: null },
      country: { type: String, required: [true, 'Country is required'] },
      zipCode: { type: String, default: null },
      lat: { type: Number, default: null },
      lng: { type: Number, default: null },
    },
    pricePerNight: {
      type: Number,
      required: [true, 'Price per night is required'],
      min: 0,
    },
    maxGuests: {
      type: Number,
      required: [true, 'Maximum guests is required'],
      min: 1,
    },
    bedrooms: {
      type: Number,
      required: [true, 'Number of bedrooms is required'],
      min: 0,
    },
    beds: {
      type: Number,
      required: [true, 'Number of beds is required'],
      min: 0,
    },
    bathrooms: {
      type: Number,
      required: [true, 'Number of bathrooms is required'],
      min: 0,
    },
    amenities: [
      {
        type: String,
        trim: true,
      },
    ],
    images: [
      {
        url: { type: String, required: true },
        caption: { type: String, default: null },
        isPrimary: { type: Boolean, default: false },
      },
    ],
    houseRules: {
      type: String,
      maxlength: 1000,
      default: null,
    },
    checkInTime: {
      type: String,
      default: '15:00',
    },
    checkOutTime: {
      type: String,
      default: '11:00',
    },
    minimumNights: {
      type: Number,
      default: 1,
      min: 1,
    },
    maximumNights: {
      type: Number,
      default: 365,
    },
    bookingType: {
      type: String,
      enum: ['instant', 'request'],
      default: 'instant',
    },
    averageRating: {
      type: Number,
      default: 0,
      min: 0,
      max: 5,
    },
    totalReviews: {
      type: Number,
      default: 0,
    },
    totalBookings: {
      type: Number,
      default: 0,
    },
    isActive: {
      type: Boolean,
      default: true,
    },
    isFeatured: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

propertySchema.index({ 'location.city': 1, 'location.country': 1 });
propertySchema.index({ pricePerNight: 1 });
propertySchema.index({ averageRating: -1 });
propertySchema.index({ host: 1 });
propertySchema.index({ category: 1 });
propertySchema.index({ isActive: 1, isFeatured: 1 });
propertySchema.index({ title: 'text', description: 'text' });

module.exports = mongoose.model('Property', propertySchema);
