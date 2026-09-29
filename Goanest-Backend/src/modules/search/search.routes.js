const express = require('express');
const router = express.Router();
const searchController = require('./search.controller');
const optionalAuth = require('../../middlewares/optionalAuth');
const validateQuery = require('../../middlewares/validateQuery');
const searchValidation = require('./search.validation');

router.get('/', optionalAuth, validateQuery(searchValidation.search), searchController.search);
router.get('/suggestions', validateQuery(searchValidation.suggestions), searchController.getSuggestions);

module.exports = router;
