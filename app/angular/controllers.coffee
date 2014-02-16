"use strict"

###
  Controllers
###

AppCtrl = ["$scope", "Scene", ($scope, Scene) ->
    $scope.scenes = Scene.$query()
]

X3domCtrl = ($scope) ->
    $scope.foo = 42
    x3dom.reload()

X3domCtrl.$inject = ["$scope"]
#
#UserDetailCtrl = ($scope, $routeParams, User) ->
#    $scope.user =
#        User.get {userId: $routeParams.userId}
#        , (data) ->
#            $scope.user = data.user
#
#UserDetailCtrl.$inject = ["$scope", "$routeParams", "User"]

SocketCtrl = ["$scope", "Socket", ($scope, Socket) ->
    Socket.on "pong", (data) ->
        $scope.response = data.data

    $scope.ping = ->
        Socket.emit("ping", {})
]
