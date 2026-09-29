const mongoose = require('mongoose');
const env = require('../config/env');
const User = require('../modules/user/user.model');
const Property = require('../modules/property/property.model');
const Favorite = require('../modules/favorite/favorite.model');
const RecentlyViewed = require('../modules/recentlyViewed/recentlyViewed.model');
const Wishlist = require('../modules/wishlist/wishlist.model');
const Booking = require('../modules/booking/booking.model');

const email = 'guest@goanest.com';
const password = 'guest123';

async function seedDemoGuest() {
  try {
    await mongoose.connect(env.MONGODB_URI, { serverSelectionTimeoutMS: 10000 });

    // Intentionally scoped to this demo account; this script never clears collections.
    let guest = await User.findOne({ email }).select('+password');
    if (!guest) {
      guest = await User.create({
        name: 'Demo Guest',
        email,
        phone: '+1-555-0101',
        password,
        role: 'user',
      });
      console.log(`Created ${email}`);
    } else {
      guest.password = password;
      guest.isActive = true;
      await guest.save();
      console.log(`Reset demo password for ${email}`);
    }

    const properties = await Property.find({ isActive: true }).sort({ createdAt: 1 }).limit(3);
    if (properties.length === 0) {
      throw new Error('No active properties found. Add properties first, then rerun this script.');
    }

    for (const property of properties) {
      await Favorite.updateOne(
        { user: guest._id, property: property._id },
        { $setOnInsert: { user: guest._id, property: property._id } },
        { upsert: true },
      );
      await RecentlyViewed.updateOne(
        { user: guest._id, property: property._id },
        { $set: { viewedAt: new Date() }, $setOnInsert: { user: guest._id, property: property._id } },
        { upsert: true },
      );
    }

    let wishlist = await Wishlist.findOne({ user: guest._id, name: 'My Goa Favorites' });
    if (!wishlist) wishlist = await Wishlist.create({ user: guest._id, name: 'My Goa Favorites', properties: [] });
    const savedIds = new Set(wishlist.properties.map((item) => item.property.toString()));
    for (const property of properties.slice(0, 2)) {
      if (!savedIds.has(property._id.toString())) wishlist.properties.push({ property: property._id });
    }
    await wishlist.save();

    if (!(await Booking.exists({ guest: guest._id }))) {
      const property = properties[0];
      const checkIn = new Date();
      checkIn.setDate(checkIn.getDate() + 20);
      const checkOut = new Date(checkIn);
      checkOut.setDate(checkOut.getDate() + 3);
      const nights = 3;
      await Booking.create({
        property: property._id,
        guest: guest._id,
        checkIn,
        checkOut,
        guests: { adults: 2, children: 0, infants: 0 },
        rooms: 1,
        nights,
        pricePerNight: property.pricePerNight,
        totalPrice: property.pricePerNight * nights,
        status: 'confirmed',
      });
    }

    console.log('Demo guest sample favorites, browsing history, wishlist, and booking are ready.');
    console.log(`Login: ${email} / ${password}`);
  } catch (error) {
    console.error('Demo guest seed failed:', error.message);
    process.exitCode = 1;
  } finally {
    await mongoose.connection.close();
  }
}

seedDemoGuest();
