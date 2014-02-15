"use strict"

###
    Declare app level module which depends on filters, services, and directives
###

angular.module("myApp", ["ngRoute", "myApp.filters", "myApp.services", "myApp.directives"])
.config ["$routeProvider", ($routeProvider) ->
    $routeProvider
        .when "/home", {templateUrl: "partials/home", controller: UsersCtrl}
        .when "/user/:userId", {templateUrl: "partials/user", controller: UserDetailCtrl}
        .when "/socket", {templateUrl: "partials/socket", controller: SocketCtrl}
        .otherwise {redirectTo: "/home"}
]


