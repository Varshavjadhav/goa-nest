const categoryService = require('./category.service');
const ApiResponse = require('../../utils/ApiResponse');
const { MESSAGES } = require('../../config/constants');
const asyncHandler = require('../../utils/asyncHandler');

const getCategories = asyncHandler(async (req, res) => {
  const categories = await categoryService.getCategories();
  return ApiResponse.success(res, MESSAGES.CATEGORIES_FETCHED, { categories });
});

module.exports = { getCategories };
