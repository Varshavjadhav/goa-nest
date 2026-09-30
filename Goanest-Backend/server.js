const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const cookieParser = require('cookie-parser');

const env = require('./src/config/env');
const connectDB = require('./src/config/db');
const routes = require('./src/routes');
const errorHandler = require('./src/middlewares/errorHandler');
const rateLimiter = require('./src/middlewares/rateLimiter');

const app = express();

// Vercel forwards requests through one trusted proxy hop.
app.set('trust proxy', 1);
app.use(helmet());
app.use(cors({ origin: '*', credentials: true }));
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(rateLimiter);

// Keep health checks independent from the database guard so they can report
// whether the API is reachable even while MongoDB is starting or unavailable.
const healthHandler = async (req, res) => {
  if (mongoose.connection.readyState !== 1) {
    try {
      await connectDB();
    } catch (error) {
      console.error(`MongoDB health check failed: ${error.message}`);
    }
  }
  const isDatabaseReady = mongoose.connection.readyState === 1;
  res.status(isDatabaseReady ? 200 : 503).json({
    status: isDatabaseReady ? 'ok' : 'degraded',
    database: isDatabaseReady ? 'connected' : 'disconnected',
  });
};
app.get('/health', healthHandler);
app.get('/api/v1/health', healthHandler);

app.use(async (req, res, next) => {
  try {
    await connectDB();
    next();
  } catch (error) {
    console.error(`MongoDB connection failed: ${error.message}`);
    res.status(503).json({
      success: false,
      message: 'Database is currently unavailable',
    });
  }
});

app.use('/api/v1', routes);

app.get('/', (req, res) => {
  res.json({ message: 'Goanest Backend API is running', version: '1.0.0' });
});

app.use(errorHandler);

let server;
if (require.main === module) {
  server = app.listen(env.PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${env.PORT} in ${env.NODE_ENV} mode`);
  });

  const shutdown = async (signal) => {
    console.log(`${signal} received, closing server and MongoDB connection`);
    if (server) await new Promise((resolve) => server.close(resolve));
    await mongoose.connection.close();
    process.exit(0);
  };

  process.once('SIGINT', shutdown);
  process.once('SIGTERM', shutdown);
}

module.exports = app;
