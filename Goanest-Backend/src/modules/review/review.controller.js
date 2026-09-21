const reviewService = require('./review.service');
const ApiResponse = require('../../utils/ApiResponse');
const { MESSAGES } = require('../../config/constants');
const asyncHandler = require('../../utils/asyncHandler');

const createReview = asyncHandler(async (req, res) => {
  const review = await reviewService.createReview(
    req.user,
    req.params.propertyId,
    req.body.booking,
    req.body
  );
  return ApiResponse.success(res, MESSAGES.REVIEW_CREATED, { review }, 201);
});

const getReviews = asyncHandler(async (req, res) => {
  const { page, limit } = req.query;
  const result = await reviewService.getReviewsByProperty(req.params.propertyId, page, limit);
  return ApiResponse.success(res, MESSAGES.REVIEWS_FETCHED, result);
});

module.exports = { createReview, getReviews };
