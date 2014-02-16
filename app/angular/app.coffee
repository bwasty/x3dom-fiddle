"use strict"

###
    Declare app level module which depends on filters, services, and directives
###

angular.module("X3domApp", ["ngRoute", "X3domApp.services", "angoose.client"])
.config ["$routeProvider", ($routeProvider) ->
    $routeProvider
        .when "/home", {templateUrl: "partials/home", controller: X3domCtrl}
        .when "/socket", {templateUrl: "partials/socket", controller: SocketCtrl}
        .otherwise {redirectTo: "/home"}
]


