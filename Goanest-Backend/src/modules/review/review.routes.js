const express = require('express');
const router = express.Router();
const reviewController = require('./review.controller');
const validate = require('../../middlewares/validate');
const reviewValidation = require('./review.validation');
const { auth } = require('../../middlewares/auth');

router.get('/:propertyId', reviewController.getReviews);
router.post('/:propertyId', auth, validate(reviewValidation.createReview), reviewController.createReview);

module.exports = router;
