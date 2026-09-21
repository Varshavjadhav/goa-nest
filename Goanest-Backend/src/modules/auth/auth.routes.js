const express = require('express');
const router = express.Router();
const authController = require('./auth.controller');
const validate = require('../../middlewares/validate');
const authValidation = require('./auth.validation');
const { auth } = require('../../middlewares/auth');

router.post('/register', validate(authValidation.register), authController.register);
router.post('/login', validate(authValidation.login), authController.login);
router.post('/refresh-token', validate(authValidation.refreshToken), authController.refreshToken);
router.post('/logout', auth, authController.logout);

module.exports = router;
