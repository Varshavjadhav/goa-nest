const express = require('express');
const router = express.Router();
const wishlistController = require('./wishlist.controller');
const { auth } = require('../../middlewares/auth');

router.get('/', auth, wishlistController.getWishlists);
router.post('/', auth, wishlistController.createWishlist);
router.put('/:id', auth, wishlistController.updateWishlist);
router.delete('/:id', auth, wishlistController.deleteWishlist);
router.post('/:id/properties/:propertyId', auth, wishlistController.addProperty);
router.delete('/:id/properties/:propertyId', auth, wishlistController.removeProperty);

module.exports = router;
