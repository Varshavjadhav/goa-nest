const express = require('express');
const router = express.Router();
const searchController = require('./search.controller');
const optionalAuth = require('../../middlewares/optionalAuth');

router.get('/', optionalAuth, searchController.search);
router.get('/suggestions', searchController.getSuggestions);

module.exports = router;
