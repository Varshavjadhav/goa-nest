const express = require('express');
const { auth, authorize } = require('../../middlewares/auth');
const controller = require('./admin.controller');

const router = express.Router();
router.use(auth, authorize('admin'));
router.get('/overview', controller.getOverview);
router.get('/properties', controller.listProperties);
router.get('/bookings', controller.listBookings);
router.patch('/bookings/:id/status', controller.updateBookingStatus);
router.get('/users', controller.listUsers);
router.patch('/users/:id/status', controller.updateUserStatus);
router.get('/categories', controller.listCategories);
router.post('/categories', controller.saveCategory);
router.put('/categories/:id', controller.updateCategory);
router.delete('/categories/:id', controller.archiveCategory);
router.get('/reviews', controller.listReviews);
router.delete('/reviews/:id', controller.deleteReview);

module.exports = router;
