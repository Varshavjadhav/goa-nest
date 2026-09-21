const Category = require('./category.model');
const ApiError = require('../../utils/ApiError');
const { MESSAGES } = require('../../config/constants');

const getCategories = async () => {
  const categories = await Category.find({ isActive: true }).sort({ name: 1 });
  return categories;
};

const getCategoryById = async (categoryId) => {
  const category = await Category.findById(categoryId);
  if (!category) {
    throw ApiError.notFound(MESSAGES.CATEGORY_NOT_FOUND);
  }
  return category;
};

module.exports = { getCategories, getCategoryById };
