angular.module("mean.system").controller "IndexController", ["$scope", "$socket", "Global", "Outings", (scope, socket, Global, Outings) ->
  scope.global = Global

  logError = (e) ->
    console.log(e)

  scope.outings = []
  Outings.myOutings((myOutings) ->
    scope.myOutings = myOutings
    Outings.query((outings) ->
      myOutingMap = {}
      myOutingMap[o._id] = true for o in myOutings
      scope.outings.push(o) for o in outings when myOutingMap[o._id] isnt true
    )
  )

  scope.joinOuting = (outing) ->
    outing.$join (->
      scope.outings = _.reject(scope.outings, (e) -> e._id == outing._id)
      scope.myOutings.push(outing)
    ),
    logError

  scope.quitOuting = (outing) ->
    outing.$quit (->
      scope.myOutings = _.reject(scope.myOutings, (e) -> e._id == outing._id)
      scope.outings.push(outing)
    ),
    logError

  scope.saveOuting = (outing) ->
    outing.$update (->
      console.log "saved"
    ),
    logError

  socket.on("outing-update", (outing) ->
    outing = JSON.parse(outing)
    dest = _.findWhere(scope.outings.concat(scope.myOutings), {_id: outing._id}) || _.findWhere(scope.outings, {_id: outing._id})
    angular.copy(outing, dest) if dest
  )
]
