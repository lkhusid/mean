###
Module dependencies.
###
mongoose = require("mongoose")
_ = require("underscore")
Outing = mongoose.model("Outing")

exports.render = (req, res) ->
  res.render "index",
    user: if req.user then JSON.stringify(req.user) else "null"
