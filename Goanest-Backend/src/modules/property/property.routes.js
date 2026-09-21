const express = require('express');
const router = express.Router();
const propertyController = require('./property.controller');
const validate = require('../../middlewares/validate');
const propertyValidation = require('./property.validation');
const { auth, authorize } = require('../../middlewares/auth');
const optionalAuth = require('../../middlewares/optionalAuth');

router.get('/', propertyController.getAllProperties);
router.get('/featured', propertyController.getFeaturedProperties);
router.get('/my-properties', auth, authorize('host', 'admin'), propertyController.getMyProperties);
router.get('/:id', optionalAuth, propertyController.getProperty);
router.get('/:id/availability', propertyController.checkAvailability);
router.post('/', auth, authorize('host', 'admin'), validate(propertyValidation.createProperty), propertyController.createProperty);
router.put('/:id', auth, authorize('host', 'admin'), validate(propertyValidation.updateProperty), propertyController.updateProperty);
router.delete('/:id', auth, authorize('host', 'admin'), propertyController.deleteProperty);

module.exports = router;
