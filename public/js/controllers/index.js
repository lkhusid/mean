(function() {
  angular.module("mean.system").controller("IndexController", [
    "$scope", "$socket", "Global", "Outings", function(scope, socket, Global, Outings) {
      var loadOutings, logError;
      scope.global = Global;
      logError = function(e) {
        return console.log(e);
      };
      loadOutings = function() {
        return Outings.query(function(outings) {
          var myOutingMap, o, _i, _j, _len, _len1, _ref, _results;
          scope.outings = [];
          myOutingMap = {};
          _ref = scope.myOutings;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            o = _ref[_i];
            myOutingMap[o._id] = true;
          }
          _results = [];
          for (_j = 0, _len1 = outings.length; _j < _len1; _j++) {
            o = outings[_j];
            if (myOutingMap[o._id] !== true) {
              _results.push(scope.outings.push(o));
            }
          }
          return _results;
        });
      };
      Outings.myOutings(function(myOutings) {
        scope.myOutings = myOutings;
        return loadOutings();
      });
      scope.joinOuting = function(outing) {
        return outing.$join((function() {
          scope.outings = _.reject(scope.outings, function(e) {
            return e._id === outing._id;
          });
          return scope.myOutings.push(outing);
        }), logError);
      };
      scope.quitOuting = function(outing) {
        return outing.$quit((function() {
          scope.myOutings = _.reject(scope.myOutings, function(e) {
            return e._id === outing._id;
          });
          return scope.outings.push(outing);
        }), logError);
      };
      scope.createOuting = function(outing) {
        return new Outings(outing).$save((function() {
          return console.log("saved");
        }), logError);
      };
      scope.saveOuting = function(outing) {
        return outing.$update((function() {
          return console.log("updated");
        }), logError);
      };
      socket.on("outing-create", function(outing) {
        return loadOutings();
      });
      return socket.on("outing-update", function(outing) {
        var dest;
        outing = JSON.parse(outing);
        dest = _.findWhere(scope.outings.concat(scope.myOutings), {
          _id: outing._id
        }) || _.findWhere(scope.outings, {
          _id: outing._id
        });
        if (dest) {
          return angular.copy(outing, dest);
        }
      });
    }
  ]);

}).call(this);
