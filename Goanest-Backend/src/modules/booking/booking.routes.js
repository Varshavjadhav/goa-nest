const express = require('express');
const router = express.Router();
const bookingController = require('./booking.controller');
const validate = require('../../middlewares/validate');
const bookingValidation = require('./booking.validation');
const { auth } = require('../../middlewares/auth');

router.get('/', auth, bookingController.getMyBookings);
router.get('/:id', auth, bookingController.getBooking);
router.post('/', auth, validate(bookingValidation.createBooking), bookingController.createBooking);
router.put('/:id/cancel', auth, validate(bookingValidation.cancelBooking), bookingController.cancelBooking);
router.get('/property/:propertyId', auth, bookingController.getPropertyBookings);

module.exports = router;
