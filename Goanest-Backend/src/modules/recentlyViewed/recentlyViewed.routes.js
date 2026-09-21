const express = require('express');
const router = express.Router();
const { auth } = require('../../middlewares/auth');
const controller = require('./recentlyViewed.controller');

router.get('/', auth, controller.getRecentlyViewed);
router.post('/:propertyId', auth, controller.markViewed);

module.exports = router;
