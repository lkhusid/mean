mongoose = require('mongoose')
Outing = mongoose.model('Outing')
_ = require('underscore')
messaging = require('./../../config/messaging')

exports.all = (req, res) ->
  Outing.find().sort('-created').exec((err, data) ->
    if (err)
      res.render('error', {status: 500})
    else
      res.jsonp(data)
  )

exports.my = (req, res) ->
  Outing.find(players: req.user.id).sort('-created').exec((err, data) ->
    if err
      res.render('error', {status: 500})
    else
      res.jsonp(data)
  )

exports.show = (req, res) ->
  res.jsonp(req.outing)

exports.create = (req, res) ->
  outing = new Outing(req.body)
  outing.players ||= []

  outing.save (err) ->
    if err
      res.render('error', {status: 500})
    else
      messaging.emit("outing-create", JSON.stringify(outing))
      res.jsonp outing

exports.update = (req, res) ->
  outing = _.extend(req.outing, req.body)
  outing.save (err) ->
    if err
      res.render('error', {status: 500})
    else
      messaging.emit("outing-update", JSON.stringify(outing))
      res.jsonp outing

exports.join = (req, res) ->
  if _.find(req.outing.players, (e) -> return e._id.toString() == req.user.id)
    res.jsonp 406, "already joined"
  else
    req.outing.players.push(req.user)
    req.outing.save (err) ->
      if err
        res.render('error', {status: 500})
      else
        res.jsonp req.outing

exports.quit = (req, res) ->
  req.outing.players = _.reject(req.outing.players, (e) -> return e._id.toString() == req.user.id)
  req.outing.save (err) ->
    if err
      res.render('error', {status: 500})
    else
      res.jsonp req.outing

exports.outing = (req, res, next, id) ->
  Outing.findOne(_id: id).populate({path: 'players', select:'name username'}).exec((err, outing) ->
    return next(err) if err
    return next(new Error('Failed to load outing ' + id)) unless outing
    req.outing = outing
    next()
  )
