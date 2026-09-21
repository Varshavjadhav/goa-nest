const express = require('express');
const router = express.Router();
const { auth } = require('../../middlewares/auth');
const favoriteController = require('./favorite.controller');

router.post('/:propertyId', auth, favoriteController.likeProperty);
router.delete('/:propertyId', auth, favoriteController.unlikeProperty);

module.exports = router;
