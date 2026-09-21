const ApiError = require('../utils/ApiError');
const { MESSAGES } = require('../config/constants');

const validate = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body, { abortEarly: false });

    if (error) {
      const message = error.details.map((detail) => detail.message).join(', ');
      return next(ApiError.badRequest(message));
    }

    next();
  };
};

module.exports = validate;
