const mongoose = require('mongoose');
const env = require('./env');

const connectDB = async () => {
  if (mongoose.connection.readyState === 1) return mongoose.connection;

  const conn = await mongoose.connect(env.MONGODB_URI, {
    serverSelectionTimeoutMS: 5000,
    connectTimeoutMS: 5000,
  });

  console.log(`MongoDB connected: ${conn.connection.host}/${conn.connection.name}`);
  return conn.connection;
};

mongoose.connection.on('disconnected', () => {
  console.error('MongoDB disconnected');
});

mongoose.connection.on('error', (error) => {
  console.error(`MongoDB error: ${error.message}`);
});

module.exports = connectDB;
