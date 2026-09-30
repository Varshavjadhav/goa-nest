const mongoose = require('mongoose');
const env = require('../config/env');
const User = require('../modules/user/user.model');

async function seedAdmin() {
  const email = process.env.ADMIN_EMAIL?.trim().toLowerCase();
  const password = process.env.ADMIN_PASSWORD;
  if (!email || !password || password.length < 8) {
    throw new Error('Set ADMIN_EMAIL and ADMIN_PASSWORD (at least 8 characters) before running this script.');
  }

  try {
    await mongoose.connect(env.MONGODB_URI, { serverSelectionTimeoutMS: 10000 });
    let admin = await User.findOne({ email }).select('+password');
    if (!admin && process.env.ADMIN_PREVIOUS_EMAIL) {
      admin = await User.findOne({ email: process.env.ADMIN_PREVIOUS_EMAIL.trim().toLowerCase() }).select('+password');
      if (admin) admin.email = email;
    }
    if (!admin) {
      admin = await User.create({
        name: process.env.ADMIN_NAME || 'GoaNest Admin',
        email,
        password,
        role: 'admin',
      });
      console.log(`Created admin account: ${email}`);
    } else {
      admin.password = password;
      admin.role = 'admin';
      admin.isActive = true;
      await admin.save();
      console.log(`Updated admin account: ${email}`);
    }
  } catch (error) {
    console.error('Admin setup failed:', error.message);
    process.exitCode = 1;
  } finally {
    await mongoose.connection.close();
  }
}

seedAdmin().catch((error) => {
  console.error('Admin setup failed:', error.message);
  process.exitCode = 1;
});
