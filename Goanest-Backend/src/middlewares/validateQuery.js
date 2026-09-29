const ApiError = require('../utils/ApiError');

const validateQuery = (schema) => (req, res, next) => {
  const { error } = schema.validate(req.query, { abortEarly: false });
  if (error) {
    const message = error.details.map((detail) => detail.message).join(', ');
    return next(ApiError.badRequest(message));
  }
  next();
};

module.exports = validateQuery;
