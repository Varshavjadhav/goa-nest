const { verifyAccessToken } = require('../utils/tokenUtils');
const ApiError = require('../utils/ApiError');
const { MESSAGES } = require('../config/constants');

const auth = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      throw ApiError.unauthorized(MESSAGES.UNAUTHORIZED);
    }

    const token = authHeader.split(' ')[1];
    const decoded = verifyAccessToken(token);

    req.user = decoded.userId;
    req.userRole = decoded.role;
    next();
  } catch (error) {
    if (error.name === 'TokenExpiredError') {
      return next(ApiError.unauthorized(MESSAGES.TOKEN_EXPIRED));
    }
    if (error.name === 'JsonWebTokenError') {
      return next(ApiError.unauthorized(MESSAGES.INVALID_TOKEN));
    }
    next(error);
  }
};

const authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.userRole || !roles.includes(req.userRole)) {
      return next(ApiError.forbidden(MESSAGES.FORBIDDEN));
    }
    next();
  };
};

module.exports = { auth, authorize };
