"use strict"

###
  Controllers
###

# TODO!: create SceneProvider (or restangular only?)
AppCtrl = ["$scope", "Restangular", ($scope, Restangular) ->
    $scope.scenes = Restangular.all('api/scenes').getList().$object
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
