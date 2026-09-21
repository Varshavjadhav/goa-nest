const express = require('express');
const router = express.Router();
const userController = require('./user.controller');
const { auth } = require('../../middlewares/auth');
const validate = require('../../middlewares/validate');
const userValidation = require('./user.validation');

router.get('/profile', auth, userController.getProfile);
router.put('/profile', auth, validate(userValidation.updateProfile), userController.updateProfile);

module.exports = router;
