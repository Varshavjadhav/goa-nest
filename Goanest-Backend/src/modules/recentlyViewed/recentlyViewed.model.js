const mongoose = require('mongoose');

const recentlyViewedSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    property: { type: mongoose.Schema.Types.ObjectId, ref: 'Property', required: true },
    viewedAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

recentlyViewedSchema.index({ user: 1, property: 1 }, { unique: true });
recentlyViewedSchema.index({ user: 1, viewedAt: -1 });

module.exports = mongoose.model('RecentlyViewed', recentlyViewedSchema);
