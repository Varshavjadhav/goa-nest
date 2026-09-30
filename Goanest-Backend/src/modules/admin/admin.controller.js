const ApiError = require('../../utils/ApiError');
const ApiResponse = require('../../utils/ApiResponse');
const asyncHandler = require('../../utils/asyncHandler');
const Booking = require('../booking/booking.model');
const Category = require('../category/category.model');
const Property = require('../property/property.model');
const Review = require('../review/review.model');
const User = require('../user/user.model');

const getOverview = asyncHandler(async (_req, res) => {
  const [properties, activeProperties, users, hosts, bookings, pendingBookings, revenue, byStatus, recentBookings] = await Promise.all([
    Property.countDocuments(),
    Property.countDocuments({ isActive: true }),
    User.countDocuments({ role: 'user' }),
    User.countDocuments({ role: 'host' }),
    Booking.countDocuments(),
    Booking.countDocuments({ status: 'pending' }),
    Booking.aggregate([
      { $match: { status: { $in: ['confirmed', 'completed'] } } },
      { $group: { _id: null, total: { $sum: '$totalPrice' } } },
    ]),
    Booking.aggregate([{ $group: { _id: '$status', count: { $sum: 1 } } }]),
    Booking.find().populate('property', 'title images location.city').populate('guest', 'name email avatar').sort({ createdAt: -1 }).limit(6),
  ]);

  return ApiResponse.success(res, 'Admin overview fetched', {
    metrics: {
      properties,
      activeProperties,
      users,
      hosts,
      bookings,
      pendingBookings,
      revenue: revenue[0]?.total || 0,
    },
    bookingsByStatus: Object.fromEntries(byStatus.map((entry) => [entry._id, entry.count])),
    recentBookings,
  });
});

const listProperties = asyncHandler(async (req, res) => {
  const page = Math.max(Number(req.query.page) || 1, 1);
  const limit = Math.min(Math.max(Number(req.query.limit) || 20, 1), 100);
  const query = {};
  if (req.query.status === 'active') query.isActive = true;
  if (req.query.status === 'inactive') query.isActive = false;
  if (req.query.search) {
    const escaped = String(req.query.search).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    query.$or = [{ title: new RegExp(escaped, 'i') }, { 'location.city': new RegExp(escaped, 'i') }];
  }
  const [items, total] = await Promise.all([
    Property.find(query).populate('host', 'name email avatar').populate('category', 'name slug icon').sort({ createdAt: -1 }).skip((page - 1) * limit).limit(limit),
    Property.countDocuments(query),
  ]);
  return ApiResponse.success(res, 'Admin properties fetched', { properties: items, total, page, limit, pages: Math.ceil(total / limit) });
});

const listBookings = asyncHandler(async (req, res) => {
  const page = Math.max(Number(req.query.page) || 1, 1);
  const limit = Math.min(Math.max(Number(req.query.limit) || 20, 1), 100);
  const query = {};
  if (req.query.status) query.status = req.query.status;
  const [items, total] = await Promise.all([
    Booking.find(query).populate('property', 'title images location.city').populate('guest', 'name email avatar').sort({ createdAt: -1 }).skip((page - 1) * limit).limit(limit),
    Booking.countDocuments(query),
  ]);
  return ApiResponse.success(res, 'Admin bookings fetched', { bookings: items, total, page, limit, pages: Math.ceil(total / limit) });
});

const updateBookingStatus = asyncHandler(async (req, res) => {
  const allowed = ['pending', 'confirmed', 'cancelled', 'completed'];
  if (!allowed.includes(req.body.status)) throw ApiError.badRequest('Invalid booking status');
  const booking = await Booking.findByIdAndUpdate(req.params.id, { status: req.body.status }, { new: true, runValidators: true })
    .populate('property', 'title images location.city').populate('guest', 'name email avatar');
  if (!booking) throw ApiError.notFound('Booking not found');
  return ApiResponse.success(res, 'Booking status updated', { booking });
});

const listUsers = asyncHandler(async (req, res) => {
  const page = Math.max(Number(req.query.page) || 1, 1);
  const limit = Math.min(Math.max(Number(req.query.limit) || 20, 1), 100);
  const query = { role: { $ne: 'admin' } };
  if (req.query.role && ['user', 'host'].includes(req.query.role)) query.role = req.query.role;
  if (req.query.search) {
    const escaped = String(req.query.search).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
    query.$or = [{ name: new RegExp(escaped, 'i') }, { email: new RegExp(escaped, 'i') }];
  }
  const [items, total] = await Promise.all([
    User.find(query).select('name email role avatar phone location isActive createdAt').sort({ createdAt: -1 }).skip((page - 1) * limit).limit(limit),
    User.countDocuments(query),
  ]);
  return ApiResponse.success(res, 'Admin users fetched', { users: items, total, page, limit, pages: Math.ceil(total / limit) });
});

const updateUserStatus = asyncHandler(async (req, res) => {
  if (typeof req.body.isActive !== 'boolean') throw ApiError.badRequest('isActive must be true or false');
  const user = await User.findOneAndUpdate(
    { _id: req.params.id, role: { $ne: 'admin' } },
    { isActive: req.body.isActive, refreshToken: null },
    { new: true },
  )
    .select('name email role avatar phone isActive createdAt');
  if (!user) throw ApiError.notFound('User not found');
  return ApiResponse.success(res, 'User status updated', { user });
});

const listCategories = asyncHandler(async (_req, res) => {
  const categories = await Category.find().sort({ name: 1 });
  return ApiResponse.success(res, 'Admin categories fetched', { categories });
});

const saveCategory = asyncHandler(async (req, res) => {
  const { name, icon, description, isActive = true } = req.body;
  if (!name || !String(name).trim()) throw ApiError.badRequest('Category name is required');
  const slug = String(req.body.slug || name).trim().toLowerCase().normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  if (!slug) throw ApiError.badRequest('Category slug is invalid');
  const category = await Category.create({ name: String(name).trim(), slug, icon: icon || null, description: description || null, isActive });
  return ApiResponse.success(res, 'Category created', { category }, 201);
});

const updateCategory = asyncHandler(async (req, res) => {
  const updates = {};
  for (const key of ['name', 'slug', 'icon', 'description', 'isActive']) {
    if (req.body[key] !== undefined) updates[key] = req.body[key];
  }
  if (updates.slug) updates.slug = String(updates.slug).trim().toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
  const category = await Category.findByIdAndUpdate(req.params.id, updates, { new: true, runValidators: true });
  if (!category) throw ApiError.notFound('Category not found');
  return ApiResponse.success(res, 'Category updated', { category });
});

const archiveCategory = asyncHandler(async (req, res) => {
  const category = await Category.findByIdAndUpdate(req.params.id, { isActive: false }, { new: true });
  if (!category) throw ApiError.notFound('Category not found');
  return ApiResponse.success(res, 'Category archived', { category });
});

const listReviews = asyncHandler(async (req, res) => {
  const page = Math.max(Number(req.query.page) || 1, 1);
  const limit = Math.min(Math.max(Number(req.query.limit) || 20, 1), 100);
  const [reviews, total] = await Promise.all([
    Review.find().populate('guest', 'name email avatar').populate('property', 'title location.city').sort({ createdAt: -1 }).skip((page - 1) * limit).limit(limit),
    Review.countDocuments(),
  ]);
  return ApiResponse.success(res, 'Admin reviews fetched', { reviews, total, page, limit, pages: Math.ceil(total / limit) });
});

const deleteReview = asyncHandler(async (req, res) => {
  const review = await Review.findByIdAndDelete(req.params.id);
  if (!review) throw ApiError.notFound('Review not found');
  const stats = await Review.aggregate([{ $match: { property: review.property } }, { $group: { _id: null, average: { $avg: '$rating' }, total: { $sum: 1 } } }]);
  await Property.findByIdAndUpdate(review.property, { averageRating: stats[0]?.average ? Math.round(stats[0].average * 10) / 10 : 0, totalReviews: stats[0]?.total || 0 });
  return ApiResponse.success(res, 'Review removed');
});

module.exports = {
  getOverview,
  listProperties,
  listBookings,
  updateBookingStatus,
  listUsers,
  updateUserStatus,
  listCategories,
  saveCategory,
  updateCategory,
  archiveCategory,
  listReviews,
  deleteReview,
};
