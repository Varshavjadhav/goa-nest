const express = require('express');
const router = express.Router();
const optionalAuth = require('../../middlewares/optionalAuth');
const homeController = require('./home.controller');

router.get('/', optionalAuth, homeController.getHome);

module.exports = router;
