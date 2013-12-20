(function() {
  angular.module("mean.outings").factory("Outings", [
    "$resource", function($resource) {
      return $resource("outings/:outingId/:action", {
        outingId: "@_id"
      }, {
        update: {
          method: "PUT"
        },
        join: {
          method: "PUT",
          params: {
            action: "join"
          }
        },
        quit: {
          method: "PUT",
          params: {
            action: "quit"
          }
        },
        myOutings: {
          method: "GET",
          params: {
            action: "my"
          },
          isArray: true
        }
      });
    }
  ]);

}).call(this);
