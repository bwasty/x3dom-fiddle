"use strict"

angular.module("X3domApp", ["ngRoute", "X3domApp.services", "restangular"])
.config ["$routeProvider", ($routeProvider) ->
    $routeProvider
        .when "/home", {templateUrl: "partials/home", controller: X3domCtrl}
        .when "/socket", {templateUrl: "partials/socket", controller: SocketCtrl}
        .otherwise {redirectTo: "/home"}
]


