const propertyService = require('./property.service');
const ApiResponse = require('../../utils/ApiResponse');
const { MESSAGES } = require('../../config/constants');
const asyncHandler = require('../../utils/asyncHandler');
const recentlyViewedService = require('../recentlyViewed/recentlyViewed.service');
const favoriteService = require('../favorite/favorite.service');

const createProperty = asyncHandler(async (req, res) => {
  const property = await propertyService.createProperty(req.user, req.body);
  return ApiResponse.success(res, MESSAGES.PROPERTY_CREATED, { property }, 201);
});

const getProperty = asyncHandler(async (req, res) => {
  const property = await propertyService.getPropertyById(req.params.id);
  if (req.user) {
    // View tracking must never prevent a user from opening a property.
    try {
      await recentlyViewedService.markViewed(req.user, req.params.id);
    } catch (error) {
      // Ignore tracking errors; the property response is still valid.
    }
  }
  const propertyData = property.toObject();
  if (req.user) {
    const likedIds = await favoriteService.getFavoritePropertyIds(req.user, [property._id]);
    propertyData.isLiked = likedIds.has(property._id.toString());
  }
  return ApiResponse.success(res, MESSAGES.PROPERTY_FETCHED, { property: propertyData });
});

const updateProperty = asyncHandler(async (req, res) => {
  const property = await propertyService.updateProperty(req.params.id, req.user, req.body);
  return ApiResponse.success(res, MESSAGES.PROPERTY_UPDATED, { property });
});

const deleteProperty = asyncHandler(async (req, res) => {
  await propertyService.deleteProperty(req.params.id, req.user);
  return ApiResponse.success(res, MESSAGES.PROPERTY_DELETED);
});

const getFeaturedProperties = asyncHandler(async (req, res) => {
  const limit = parseInt(req.query.limit) || 10;
  const properties = await propertyService.getFeaturedProperties(limit);
  return ApiResponse.success(res, MESSAGES.FEATURED_PROPERTIES_FETCHED, { properties });
});

const getMyProperties = asyncHandler(async (req, res) => {
  const { page, limit } = req.query;
  const result = await propertyService.getPropertiesByHost(req.user, page, limit);
  return ApiResponse.success(res, MESSAGES.PROPERTIES_FETCHED, result);
});

const getAllProperties = asyncHandler(async (req, res) => {
  const result = await propertyService.getProperties(req.query);
  return ApiResponse.success(res, MESSAGES.PROPERTIES_FETCHED, result);
});

const checkAvailability = asyncHandler(async (req, res) => {
  const { checkIn, checkOut, guests, rooms } = req.query;
  if (!checkIn || !checkOut) {
    return ApiResponse.error(res, MESSAGES.CHECK_IN_CHECK_OUT_REQUIRED, 400);
  }
  const result = await propertyService.checkAvailability(req.params.id, checkIn, checkOut, guests, rooms);
  return ApiResponse.success(res, 'Availability checked successfully', result);
});

const checkAvailabilityPost = asyncHandler(async (req, res) => {
  const { propertyId, checkIn, checkOut, guests, rooms } = req.body;
  if (!propertyId || !checkIn || !checkOut) {
    return ApiResponse.error(res, MESSAGES.CHECK_IN_CHECK_OUT_REQUIRED, 400);
  }
  const result = await propertyService.checkAvailability(propertyId, checkIn, checkOut, guests, rooms);
  return ApiResponse.success(res, 'Availability checked successfully', result);
});

module.exports = {
  createProperty,
  getProperty,
  updateProperty,
  deleteProperty,
  getFeaturedProperties,
  getMyProperties,
  getAllProperties,
  checkAvailability,
  checkAvailabilityPost,
};
