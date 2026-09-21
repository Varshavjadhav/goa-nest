const { verifyAccessToken } = require('../utils/tokenUtils');

// Adds req.user when a valid bearer token is supplied, but keeps public
// endpoints usable for logged-out users.
const optionalAuth = (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;
    if (authHeader && authHeader.startsWith('Bearer ')) {
      const decoded = verifyAccessToken(authHeader.split(' ')[1]);
      req.user = decoded.userId;
      req.userRole = decoded.role;
    }
  } catch (error) {
    // An invalid optional token should not make a public home request fail.
  }
  next();
};

module.exports = optionalAuth;
