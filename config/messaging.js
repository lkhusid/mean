var socketIO;

module.exports = function(server) {
  socketIO = require('socket.io').listen(server);
  return socketIO;
};

module.exports.emit = function(topic, data) {
  socketIO.sockets.emit(topic, data)
};
