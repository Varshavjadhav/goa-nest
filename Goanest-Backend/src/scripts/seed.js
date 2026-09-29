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
    minimumNights: 1,
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
    minimumNights: 1,
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
    minimumNights: 1,
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
    minimumNights: 1,
    isFeatured: true,
    averageRating: 4.95,
    totalReviews: 45,
  },
];

const additionalStays = [
  { title: 'Morjim Dune House', city: 'Morjim', address: '7 Turtle Beach Road', type: 'villa', price: 5200, guests: 6, beds: 3, bedrooms: 3, bathrooms: 2, lat: 15.6300, lng: 73.7370, image: 'photo-1600596542815-ffad4c1539a9', rating: 4.8, reviews: 76, bookings: 38 },
  { title: 'Vagator Sunset Studio', city: 'Vagator', address: '14 Ozran View', type: 'apartment', price: 2400, guests: 2, beds: 1, bedrooms: 1, bathrooms: 1, lat: 15.5970, lng: 73.7350, image: 'photo-1600607687939-ce8a6c25118c', rating: 4.6, reviews: 53, bookings: 29 },
  { title: 'Candolim Courtyard Retreat', city: 'Candolim', address: '28 Fort Aguada Road', type: 'house', price: 4700, guests: 5, beds: 3, bedrooms: 2, bathrooms: 2, lat: 15.5180, lng: 73.7620, image: 'photo-1600566753086-00f18fb6b3ea', rating: 4.7, reviews: 61, bookings: 42 },
  { title: 'Siolim River View Home', city: 'Siolim', address: '3 Chapora Riverside', type: 'house', price: 3900, guests: 4, beds: 2, bedrooms: 2, bathrooms: 2, lat: 15.6170, lng: 73.7650, image: 'photo-1600047509807-ba8f99d2cdde', rating: 4.9, reviews: 44, bookings: 31 },
  { title: 'Mapusa Market Loft', city: 'Mapusa', address: '19 Market Lane', type: 'apartment', price: 1800, guests: 2, beds: 1, bedrooms: 1, bathrooms: 1, lat: 15.5910, lng: 73.8080, image: 'photo-1600607687920-4e2a09cf159d', rating: 4.4, reviews: 35, bookings: 25 },
  { title: 'Dona Paula Sea Glass Villa', city: 'Dona Paula', address: '5 Bay View Road', type: 'villa', price: 7200, guests: 8, beds: 5, bedrooms: 4, bathrooms: 3, lat: 15.4580, lng: 73.8050, image: 'photo-1600210492486-724fe5c67fb0', rating: 4.9, reviews: 92, bookings: 55 },
  { title: 'Panaji Heritage Flat', city: 'Panaji', address: '22 Fontainhas Street', type: 'apartment', price: 3100, guests: 3, beds: 2, bedrooms: 2, bathrooms: 1, lat: 15.4980, lng: 73.8270, image: 'photo-1600566753190-17f0baa2a6c3', rating: 4.5, reviews: 48, bookings: 34 },
  { title: 'Benaulim Coconut Grove Stay', city: 'Benaulim', address: '11 Beach Road', type: 'cottage', price: 3600, guests: 4, beds: 2, bedrooms: 2, bathrooms: 1, lat: 15.2640, lng: 73.9290, image: 'photo-1613977257363-707ba9348227', rating: 4.8, reviews: 57, bookings: 37 },
  { title: 'Colva Palm Garden Bungalow', city: 'Colva', address: '9 Sernabatim Lane', type: 'house', price: 3300, guests: 5, beds: 3, bedrooms: 2, bathrooms: 2, lat: 15.2790, lng: 73.9220, image: 'photo-1600607687644-c7171b42498f', rating: 4.6, reviews: 42, bookings: 28 },
  { title: 'Agonda Quiet Cove Cottage', city: 'Agonda', address: '2 Agonda Beach Path', type: 'cottage', price: 2900, guests: 3, beds: 2, bedrooms: 1, bathrooms: 1, lat: 15.0430, lng: 73.9880, image: 'photo-1600607688969-a5bfcd646154', rating: 4.9, reviews: 81, bookings: 46 },
  { title: 'Cavelossim Backwater Villa', city: 'Cavelossim', address: '6 Sal River Road', type: 'villa', price: 6100, guests: 6, beds: 4, bedrooms: 3, bathrooms: 2, lat: 15.1720, lng: 73.9410, image: 'photo-1600607687939-ce8a6c25118c', rating: 4.7, reviews: 66, bookings: 50 },
  { title: 'Mandrem Sunrise Treehouse', city: 'Mandrem', address: '4 Junas Waddo', type: 'treehouse', price: 4100, guests: 2, beds: 1, bedrooms: 1, bathrooms: 1, lat: 15.6670, lng: 73.7380, image: 'photo-1520250497591-112f2f40a3f4', rating: 4.8, reviews: 39, bookings: 26 },
  { title: 'Querim Cliffside Hideaway', city: 'Querim', address: '1 Tiracol Fort Road', type: 'cottage', price: 4500, guests: 3, beds: 2, bedrooms: 1, bathrooms: 1, lat: 15.7210, lng: 73.7040, image: 'photo-1510798831971-661eb04b3739', rating: 4.7, reviews: 31, bookings: 22 },
  { title: 'Navelim Family Garden Home', city: 'Navelim', address: '16 Church Road', type: 'house', price: 2600, guests: 6, beds: 4, bedrooms: 3, bathrooms: 2, lat: 15.2710, lng: 73.9580, image: 'photo-1502672260266-1c1ef2d93688', rating: 4.5, reviews: 46, bookings: 32 },
  { title: 'Betalbatim Beachside Suite', city: 'Betalbatim', address: '8 Sunset Lane', type: 'apartment', price: 3400, guests: 3, beds: 2, bedrooms: 1, bathrooms: 1, lat: 15.3040, lng: 73.9100, image: 'photo-1587061949409-02df41d5e562', rating: 4.8, reviews: 59, bookings: 41 },
].map((stay, index) => {
  const template = sampleProperties[index % sampleProperties.length];
  return {
    ...template,
    title: stay.title,
    description: `A welcoming ${stay.type} in ${stay.city}, Goa, with thoughtful comforts and easy access to the coast, local cafes, and village life.`,
    propertyType: stay.type,
    location: { ...template.location, address: stay.address, city: stay.city, lat: stay.lat, lng: stay.lng },
    pricePerNight: stay.price,
    maxGuests: stay.guests,
    bedrooms: stay.bedrooms,
    beds: stay.beds,
    bathrooms: stay.bathrooms,
    images: [{ url: `https://images.unsplash.com/${stay.image}?w=800`, isPrimary: true }],
    averageRating: stay.rating,
    totalReviews: stay.reviews,
    totalBookings: stay.bookings,
  };
});
const allSampleProperties = [...sampleProperties, ...additionalStays];

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

    const propertiesWithHost = allSampleProperties.map((prop, i) => ({
      ...prop,
      host: host._id,
      category: categoryMap[i % categoryMap.length]?._id,
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
