const express = require('express');
const router = express.Router();
const optionalAuth = require('../../middlewares/optionalAuth');
const exploreController = require('./explore.controller');

router.get('/', optionalAuth, exploreController.getExplore);

module.exports = router;
