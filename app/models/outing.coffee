mongoose = require('mongoose')

OutingSchema = new mongoose.Schema({
  created: {type: Date, default: Date.now},
  title:   {type: String, default: '', trim: true},
  players: [{type: mongoose.Schema.ObjectId, ref: 'User'}],
  creator: {type: mongoose.Schema.ObjectId, ref: 'User' }
})

mongoose.model('Outing', OutingSchema);
