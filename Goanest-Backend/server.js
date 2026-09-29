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

app.use(helmet());
app.use(cors({ origin: '*', credentials: true }));
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cookieParser());
app.use(rateLimiter);

app.use('/api/v1', routes);

app.get('/', (req, res) => {
  res.json({ message: 'Goanest Backend API is running', version: '1.0.0' });
});

app.get('/health', (req, res) => {
  const isDatabaseReady = mongoose.connection.readyState === 1;
  res.status(isDatabaseReady ? 200 : 503).json({
    status: isDatabaseReady ? 'ok' : 'degraded',
    database: isDatabaseReady ? 'connected' : 'disconnected',
  });
});

app.use(errorHandler);

let server;
let retryTimer;
let shuttingDown = false;

const connectDBWithRetry = async () => {
  if (shuttingDown) return;

  try {
    await connectDB();
  } catch (error) {
    console.error(`MongoDB unavailable; retrying in 5 seconds: ${error.message}`);
    retryTimer = setTimeout(connectDBWithRetry, 5000);
  }
};

const startServer = () => {
  server = app.listen(env.PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${env.PORT} in ${env.NODE_ENV} mode`);
    void connectDBWithRetry();
  });
};

const shutdown = async (signal) => {
  shuttingDown = true;
  clearTimeout(retryTimer);
  console.log(`${signal} received, closing server and MongoDB connection`);
  if (server) {
    await new Promise((resolve) => server.close(resolve));
  }
  await mongoose.connection.close();
  process.exit(0);
};

process.once('SIGINT', shutdown);
process.once('SIGTERM', shutdown);
startServer();

module.exports = app;
