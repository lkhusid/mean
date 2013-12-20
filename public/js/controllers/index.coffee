angular.module("mean.system").controller "IndexController", ["$scope", "$socket", "Global", "Outings", (scope, socket, Global, Outings) ->
  scope.global = Global

  logError = (e) ->
    console.log(e)

  loadOutings = ->
    Outings.query((outings) ->
      scope.outings = []
      myOutingMap = {}
      myOutingMap[o._id] = true for o in scope.myOutings
      scope.outings.push(o) for o in outings when myOutingMap[o._id] isnt true
    )

  Outings.myOutings((myOutings) ->
    scope.myOutings = myOutings
    loadOutings()
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

  scope.createOuting = (outing) ->
    new Outings(outing).$save (->
      console.log "saved"
    ),
    logError

  scope.saveOuting = (outing) ->
    outing.$update (->
      console.log "updated"
    ),
    logError

  socket.on("outing-create", (outing) ->
    loadOutings()
  )

  socket.on("outing-update", (outing) ->
    outing = JSON.parse(outing)
    dest = _.findWhere(scope.outings.concat(scope.myOutings), {_id: outing._id}) || _.findWhere(scope.outings, {_id: outing._id})
    angular.copy(outing, dest) if dest
  )
]
