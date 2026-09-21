const mongoose = require('mongoose');
const env = require('../config/env');

const Category = require('../modules/category/category.model');
const User = require('../modules/user/user.model');
const Property = require('../modules/property/property.model');
const Booking = require('../modules/booking/booking.model');
const Review = require('../modules/review/review.model');
const Wishlist = require('../modules/wishlist/wishlist.model');
const Favorite = require('../modules/favorite/favorite.model');
const RecentlyViewed = require('../modules/recentlyViewed/recentlyViewed.model');
const Conversation = require('../modules/conversation/conversation.model');
const Message = require('../modules/conversation/message.model');

const categories = [
  { name: 'Trending', slug: 'trending', icon: '🔥', description: 'Most popular properties right now' },
  { name: 'Beachfront', slug: 'beachfront', icon: '🏖️', description: 'Properties right on the beach' },
  { name: 'Cabins', slug: 'cabins', icon: '🛖', description: 'Cozy cabins in nature' },
  { name: 'Design', slug: 'design', icon: '🎨', description: 'Architecturally stunning homes' },
  { name: 'OMG!', slug: 'omg', icon: '😲', description: 'Unique and unbelievable properties' },
  { name: 'Castles', slug: 'castles', icon: '🏰', description: 'Stay in a real castle' },
  { name: 'Lakefront', slug: 'lakefront', icon: '🌊', description: 'Properties on lakes' },
  { name: 'Tiny Homes', slug: 'tiny-homes', icon: '🏠', description: 'Small but perfectly formed' },
  { name: 'Treehouses', slug: 'treehouses', icon: '🌳', description: 'Elevated stays in the trees' },
  { name: 'Countryside', slug: 'countryside', icon: '🌾', description: 'Rural retreats' },
  { name: 'Amazing Views', slug: 'amazing-views', icon: '🌄', description: 'Properties with breathtaking views' },
  { name: 'Pools', slug: 'pools', icon: '🏊', description: 'Properties with private pools' },
];

const sampleHost = {
  name: 'Demo Host',
  email: 'host@goanest.com',
  password: 'host123',
  role: 'host',
  bio: 'Experienced host with a passion for hospitality',
  phone: '+1-555-0100',
};

const sampleUser = {
  name: 'Demo Guest',
  email: 'guest@goanest.com',
  phone: '+1-555-0101',
  password: 'guest123',
  role: 'user',
};

const sampleProperties = [
  {
    title: 'Stylish Big 1BHK with Pool Balcony',
    description: 'Stunning beachfront villa with panoramic ocean views, private infinity pool, and direct beach access. Perfect for a luxurious getaway.',
    propertyType: 'villa',
    location: { address: '123 Arpora Road', city: 'Arpora', state: 'Goa', country: 'India', lat: 15.5527, lng: 73.7938 },
    pricePerNight: 3000,
    maxGuests: 8,
    bedrooms: 4,
    beds: 5,
    bathrooms: 3,
    amenities: ['Wifi', 'Pool', 'Kitchen', 'Beach access', 'Air conditioning', 'Free parking', 'Washer', 'Dryer'],
    images: [{ url: 'https://images.unsplash.com/photo-1613490493576-7fde63acd811?w=800', isPrimary: true }],
    checkInTime: '15:00',
    checkOutTime: '11:00',
    minimumNights: 2,
    isFeatured: true,
    averageRating: 4.9,
    totalReviews: 127,
  },
  {
    title: 'Coco Palm Beach Villa',
    description: 'Rustic cabin nestled in the mountains with a fireplace, hot tub, and stunning forest views. Ideal for nature lovers.',
    propertyType: 'villa',
    location: { address: '456 Anjuna Beach Road', city: 'Anjuna', state: 'Goa', country: 'India', lat: 15.5736, lng: 73.7414 },
    pricePerNight: 6500,
    maxGuests: 6,
    bedrooms: 3,
    beds: 4,
    bathrooms: 2,
    amenities: ['Wifi', 'Pool', 'Kitchen', 'Beach access', 'Air conditioning', 'Free parking'],
    images: [{ url: 'https://images.unsplash.com/photo-1587061949409-02df41d5e562?w=800', isPrimary: true }],
    checkInTime: '16:00',
    checkOutTime: '10:00',
    minimumNights: 2,
    isFeatured: true,
    averageRating: 4.8,
    totalReviews: 89,
  },
  {
    title: 'Modern Calangute Loft',
    description: 'Sleek and modern loft in the heart of the city. Walking distance to restaurants, shops, and nightlife.',
    propertyType: 'apartment',
    location: { address: '789 Main Street', city: 'Calangute', state: 'Goa', country: 'India', lat: 15.5449, lng: 73.7553 },
    pricePerNight: 2800,
    maxGuests: 4,
    bedrooms: 2,
    beds: 2,
    bathrooms: 1,
    amenities: ['Wifi', 'Kitchen', 'Gym', 'Doorman', 'Elevator', 'Air conditioning'],
    images: [{ url: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800', isPrimary: true }],
    checkInTime: '15:00',
    checkOutTime: '11:00',
    minimumNights: 1,
    isFeatured: true,
    averageRating: 4.7,
    totalReviews: 203,
  },
  {
    title: 'Charming Assagao Garden Cottage',
    description: 'Beautiful stone cottage in the rolling countryside with a private garden and stunning sunset views.',
    propertyType: 'cottage',
    location: { address: '12 Meadow Lane', city: 'Assagao', state: 'Goa', country: 'India', lat: 15.5860, lng: 73.7890 },
    pricePerNight: 4200,
    maxGuests: 4,
    bedrooms: 2,
    beds: 3,
    bathrooms: 1,
    amenities: ['Wifi', 'Garden', 'Fireplace', 'Kitchen', 'Free parking', 'Countryside views'],
    images: [{ url: 'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=800', isPrimary: true }],
    checkInTime: '15:00',
    checkOutTime: '10:00',
    minimumNights: 2,
    isFeatured: true,
    averageRating: 4.9,
    totalReviews: 64,
  },
  {
    title: 'South Goa Forest Hideaway',
    description: 'Unique treehouse experience surrounded by nature with modern amenities and breathtaking canopy views.',
    propertyType: 'treehouse',
    location: { address: '88 Forest Trail', city: 'Palolem', state: 'Goa', country: 'India', lat: 15.0099, lng: 74.0232 },
    pricePerNight: 3500,
    maxGuests: 2,
    bedrooms: 1,
    beds: 1,
    bathrooms: 1,
    amenities: ['Wifi', 'Kitchen', 'Outdoor shower', 'Nature views', 'Hiking trails'],
    images: [{ url: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=800', isPrimary: true }],
    checkInTime: '14:00',
    checkOutTime: '11:00',
    minimumNights: 2,
    isFeatured: true,
    averageRating: 4.95,
    totalReviews: 45,
  },
];

const seed = async () => {
  try {
    await mongoose.connect(env.MONGODB_URI, {
      serverSelectionTimeoutMS: 5000,
      connectTimeoutMS: 5000,
    });
    console.log('Connected to MongoDB');

    await Category.deleteMany({});
    await User.deleteMany({ email: { $in: ['host@goanest.com', 'guest@goanest.com'] } });
    await Property.deleteMany({});
    await Promise.all([
      Booking.deleteMany({}),
      Review.deleteMany({}),
      Wishlist.deleteMany({}),
      Favorite.deleteMany({}),
      RecentlyViewed.deleteMany({}),
      Conversation.deleteMany({}),
      Message.deleteMany({}),
    ]);

    const createdCategories = await Category.insertMany(categories);
    console.log(`Seeded ${createdCategories.length} categories`);

    const host = await User.create(sampleHost);
    console.log(`Created host: ${host.email}`);

    const guest = await User.create(sampleUser);
    console.log(`Created guest: ${guest.email}`);

    const trendingCategory = createdCategories.find((c) => c.slug === 'trending');
    const beachCategory = createdCategories.find((c) => c.slug === 'beachfront');
    const cabinCategory = createdCategories.find((c) => c.slug === 'cabins');
    const designCategory = createdCategories.find((c) => c.slug === 'design');
    const treehouseCategory = createdCategories.find((c) => c.slug === 'treehouses');

    const categoryMap = [beachCategory, beachCategory, designCategory, trendingCategory, treehouseCategory];

    const propertiesWithHost = sampleProperties.map((prop, i) => ({
      ...prop,
      host: host._id,
      category: categoryMap[i]?._id,
    }));

    const createdProperties = await Property.insertMany(propertiesWithHost);
    console.log(`Seeded ${createdProperties.length} properties`);

    // Demo data for the authenticated guest account. These records make every
    // guest-facing app screen usable immediately after running this script.
    await Favorite.insertMany([
      { user: guest._id, property: createdProperties[0]._id },
      { user: guest._id, property: createdProperties[2]._id },
    ]);

    const viewedAt = [1, 2, 3, 4].map((daysAgo) => {
      const date = new Date();
      date.setDate(date.getDate() - daysAgo);
      return date;
    });
    await RecentlyViewed.insertMany(createdProperties.slice(0, 4).map((property, index) => ({
      user: guest._id,
      property: property._id,
      viewedAt: viewedAt[index],
    })));

    await Wishlist.create({
      user: guest._id,
      name: 'My Goa Favorites',
      properties: [
        { property: createdProperties[0]._id },
        { property: createdProperties[1]._id },
      ],
    });

    const completedCheckIn = new Date();
    completedCheckIn.setDate(completedCheckIn.getDate() - 30);
    const completedCheckOut = new Date();
    completedCheckOut.setDate(completedCheckOut.getDate() - 25);
    const completedBooking = await Booking.create({
      property: createdProperties[0]._id,
      guest: guest._id,
      checkIn: completedCheckIn,
      checkOut: completedCheckOut,
      guests: { adults: 2, children: 0, infants: 0 },
      nights: 5,
      pricePerNight: createdProperties[0].pricePerNight,
      totalPrice: createdProperties[0].pricePerNight * 5,
      cleaningFee: 23,
      serviceFee: 315,
      status: 'completed',
      specialRequests: 'Late check-in requested',
    });

    const confirmedCheckIn = new Date();
    confirmedCheckIn.setDate(confirmedCheckIn.getDate() + 20);
    const confirmedCheckOut = new Date();
    confirmedCheckOut.setDate(confirmedCheckOut.getDate() + 23);
    await Booking.create({
      property: createdProperties[1]._id,
      guest: guest._id,
      checkIn: confirmedCheckIn,
      checkOut: confirmedCheckOut,
      guests: { adults: 2, children: 1, infants: 0 },
      nights: 3,
      pricePerNight: createdProperties[1].pricePerNight,
      totalPrice: createdProperties[1].pricePerNight * 3,
      cleaningFee: 14,
      serviceFee: 116,
      status: 'confirmed',
    });

    const cancelledCheckIn = new Date();
    cancelledCheckIn.setDate(cancelledCheckIn.getDate() + 45);
    const cancelledCheckOut = new Date();
    cancelledCheckOut.setDate(cancelledCheckOut.getDate() + 48);
    await Booking.create({
      property: createdProperties[2]._id,
      guest: guest._id,
      checkIn: cancelledCheckIn,
      checkOut: cancelledCheckOut,
      guests: { adults: 1, children: 0, infants: 0 },
      nights: 3,
      pricePerNight: createdProperties[2].pricePerNight,
      totalPrice: createdProperties[2].pricePerNight * 3,
      cleaningFee: 10,
      serviceFee: 84,
      status: 'cancelled',
      cancellationReason: 'Change of travel plans',
    });

    await Review.create({
      property: createdProperties[0]._id,
      guest: guest._id,
      booking: completedBooking._id,
      rating: 5,
      comment: 'Beautiful property, excellent host, and an unforgettable stay.',
      cleanliness: 5,
      accuracy: 5,
      communication: 5,
      location: 5,
      checkIn: 5,
      value: 4,
    });

    await Property.findByIdAndUpdate(createdProperties[0]._id, {
      averageRating: 5,
      totalReviews: 1,
      totalBookings: 1,
    });

    const conversation = await Conversation.create({
      participants: [guest._id, host._id],
      property: createdProperties[0]._id,
      booking: completedBooking._id,
      lastMessage: 'Thanks for the wonderful stay!',
      lastMessageAt: new Date(),
      lastMessageBy: guest._id,
      unreadCount: { [host._id.toString()]: 1 },
    });
    await Message.create([
      { conversation: conversation._id, sender: host._id, content: 'Welcome! Let me know if you need anything.' },
      { conversation: conversation._id, sender: guest._id, content: 'Thanks for the wonderful stay!' },
    ]);

    console.log('Seeded favorites, recently viewed, wishlist, bookings, review, and conversation data');

    console.log('\n--- Seed Complete ---');
    console.log('Host: host@goanest.com / host123');
    console.log('Guest: guest@goanest.com / guest123');

  } catch (error) {
    console.error('Seed error:', error);
    process.exitCode = 1;
  } finally {
    await mongoose.connection.close();
  }
};

seed();
