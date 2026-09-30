const Property = require('./property.model');
const User = require('../user/user.model');
const ApiError = require('../../utils/ApiError');
const { MESSAGES } = require('../../config/constants');

const createProperty = async (hostId, data, isAdmin = false) => {
  const { hostId: assignedHostId, ...propertyData } = data;
  if (isAdmin && assignedHostId && !(await User.exists({ _id: assignedHostId, role: 'host' }))) {
    throw ApiError.badRequest('Choose an existing host for this property');
  }
  const property = await Property.create({
    ...propertyData,
    host: isAdmin && assignedHostId ? assignedHostId : hostId,
  });
  return property;
};

const getPropertyById = async (propertyId) => {
  const property = await Property.findById(propertyId)
    .populate('host', 'name avatar bio location')
    .populate('category', 'name slug icon');

  if (!property) {
    throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
  }

  return property;
};

const updateProperty = async (propertyId, hostId, updateData, isAdmin = false) => {
  const property = await Property.findOne(isAdmin ? { _id: propertyId } : { _id: propertyId, host: hostId });
  if (!property) {
    throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
  }

  if (isAdmin && updateData.hostId) {
    if (!(await User.exists({ _id: updateData.hostId, role: 'host' }))) {
      throw ApiError.badRequest('Choose an existing host for this property');
    }
    property.host = updateData.hostId;
  }

  const allowedFields = [
    'title', 'description', 'propertyType', 'category', 'location',
    'pricePerNight', 'maxGuests', 'bedrooms', 'beds', 'bathrooms',
    'amenities', 'images', 'houseRules', 'checkInTime', 'checkOutTime',
    'minimumNights', 'maximumNights', 'isActive', 'isFeatured',
  ];

  for (const field of allowedFields) {
    if (updateData[field] !== undefined) {
      property[field] = updateData[field];
    }
  }

  await property.save();
  return property;
};

const deleteProperty = async (propertyId, hostId, isAdmin = false) => {
  const property = await Property.findOneAndDelete(isAdmin ? { _id: propertyId } : { _id: propertyId, host: hostId });
  if (!property) {
    throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
  }
  return true;
};

const getFeaturedProperties = async (limit = 10) => {
  const properties = await Property.find({ isActive: true, isFeatured: true })
    .populate('host', 'name avatar')
    .populate('category', 'name slug icon')
    .sort({ averageRating: -1 })
    .limit(limit);
  return properties;
};

const getPropertiesByHost = async (hostId, page = 1, limit = 20) => {
  const skip = (page - 1) * limit;
  const [properties, total] = await Promise.all([
    Property.find({ host: hostId })
      .populate('category', 'name slug icon')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit),
    Property.countDocuments({ host: hostId }),
  ]);
  return { properties, total, page, pages: Math.ceil(total / limit) };
};

const getProperties = async (filters = {}) => {
  const page = Math.max(Number(filters.page) || 1, 1);
  const limit = Math.min(Math.max(Number(filters.limit) || 20, 1), 100);
  const skip = (page - 1) * limit;

  const query = { isActive: true };

  if (filters.city) query['location.city'] = new RegExp(filters.city, 'i');
  if (filters.country) query['location.country'] = new RegExp(filters.country, 'i');
  if (filters.propertyType) {
    const values = String(filters.propertyType).split(',').map((value) => value.trim()).filter(Boolean);
    query.propertyType = values.length > 1 ? { $in: values } : values[0];
  }
  if (filters.category) query.category = filters.category;
  if (filters.minPrice || filters.maxPrice) {
    query.pricePerNight = {};
    if (filters.minPrice) query.pricePerNight.$gte = Number(filters.minPrice);
    if (filters.maxPrice) query.pricePerNight.$lte = Number(filters.maxPrice);
  }
  if (filters.maxGuests) query.maxGuests = { $gte: Number(filters.maxGuests) };
  if (filters.bedrooms) query.bedrooms = { $gte: Number(filters.bedrooms) };
  if (filters.amenities) {
    const amenityList = String(filters.amenities).split(',').map((value) => value.trim()).filter(Boolean);
    query.amenities = { $all: amenityList };
  }
  if (filters.minRating) {
    query.averageRating = { $gte: Number(filters.minRating) };
  }
  if (filters.search) {
    const text = String(filters.search).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    query.$or = [
      { title: new RegExp(text, 'i') },
      { description: new RegExp(text, 'i') },
      { 'location.city': new RegExp(text, 'i') },
      { 'location.country': new RegExp(text, 'i') },
    ];
  }

  const sort = filters.sortBy === 'price_asc'
    ? { pricePerNight: 1 }
    : filters.sortBy === 'price_desc'
    ? { pricePerNight: -1 }
    : filters.sortBy === 'rating'
    ? { averageRating: -1 }
    : { createdAt: -1 };

  const [properties, total] = await Promise.all([
    Property.find(query)
      .populate('host', 'name avatar')
      .populate('category', 'name slug icon')
      .sort(sort)
      .skip(skip)
      .limit(limit),
    Property.countDocuments(query),
  ]);

  return { properties, total, page, limit, pages: Math.ceil(total / limit) };
};

const checkAvailability = async (propertyId, checkIn, checkOut, guests = 1, rooms = 1, userId = null) => {
  const property = await Property.findById(propertyId);
  if (!property) {
    throw ApiError.notFound(MESSAGES.PROPERTY_NOT_FOUND);
  }

  const checkInDate = new Date(checkIn);
  const checkOutDate = new Date(checkOut);
  if (Number.isNaN(checkInDate.getTime()) || Number.isNaN(checkOutDate.getTime()) || checkOutDate <= checkInDate) {
    throw ApiError.badRequest(MESSAGES.CHECK_OUT_AFTER_CHECK_IN);
  }

  const Booking = require('../booking/booking.model');
  const overlappingDates = {
    property: propertyId,
    status: { $in: ['pending', 'confirmed'] },
    checkIn: { $lt: checkOutDate },
    checkOut: { $gt: checkInDate },
  };
  const [overlapping, alreadyBooked] = await Promise.all([
    Booking.countDocuments(overlappingDates),
    userId ? Booking.exists({ ...overlappingDates, guest: userId }) : null,
  ]);

  const totalGuests = Number(guests) || 1;
  const roomCount = Math.max(Number(rooms) || 1, 1);
  if (totalGuests > property.maxGuests) {
    throw ApiError.badRequest(`Maximum ${property.maxGuests} guests allowed`);
  }

  const nights = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24));
  if (nights < property.minimumNights) {
    throw ApiError.badRequest(`Minimum stay is ${property.minimumNights} night(s)`);
  }
  if (nights > property.maximumNights) {
    throw ApiError.badRequest(`Maximum stay is ${property.maximumNights} night(s)`);
  }

  const nightlyAmount = property.pricePerNight * roomCount;
  const stayAmount = nightlyAmount * nights;
  const cleaningFee = Math.round(stayAmount * 0.05);
  const serviceFee = Math.round(stayAmount * 0.08);
  const tax = Math.round((stayAmount + cleaningFee + serviceFee) * 0.05);
  const totalAmount = stayAmount + cleaningFee + serviceFee + tax;
  const available = overlapping === 0;

  return {
    available,
    bookingType: property.bookingType || 'instant',
    message: available
      ? 'Dates are available.'
      : alreadyBooked
        ? 'You already have an active booking for this property during the selected dates. Choose different dates or check My Bookings.'
        : MESSAGES.PROPERTY_NOT_AVAILABLE,
    nights,
    guests: totalGuests,
    rooms: roomCount,
    nightlyAmount,
    cleaningFee,
    serviceFee,
    tax,
    discount: 0,
    totalAmount,
    price: { nightlyAmount, cleaningFee, serviceFee, tax, discount: 0, totalAmount },
    property: {
      id: property._id,
      pricePerNight: property.pricePerNight,
      minimumNights: property.minimumNights,
      maximumNights: property.maximumNights,
    },
  };
};

module.exports = {
  createProperty,
  getPropertyById,
  updateProperty,
  deleteProperty,
  getFeaturedProperties,
  getPropertiesByHost,
  getProperties,
  checkAvailability,
};
