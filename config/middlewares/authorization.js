var _ = require("underscore");

/**
 * Generic require login routing middleware
 */
exports.requiresLogin = function (req, res, next) {
  if (!req.isAuthenticated()) {
    return res.send(401, 'User is not authorized');
  }
  next();
};

/**
 * User authorizations routing middleware
 */
exports.user = {
  hasAuthorization: function (req, res, next) {
    if (req.profile.id != req.user.id) {
      return res.send(401, 'User is not authorized');
    }
    next();
  }
};

/**
 * Article authorizations routing middleware
 */
exports.article = {
  hasAuthorization: function (req, res, next) {
    if (req.article.user.id != req.user.id) {
      return res.send(401, 'User is not authorized');
    }
    next();
  }
};

exports.outing = {
  hasAuthorization: function (req, res, next) {
    if (!_.find(req.outing.players, function(e) {return e._id.toString() == req.user.id})) {
      return res.send(401, 'User is not authorized');
    }
    next();
  }
};
