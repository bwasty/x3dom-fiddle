"use strict"

socketServer = document.domain

angular.module("X3domApp.services", [])
.factory("Socket", ["$rootScope", ($rootScope) ->
    socketService = {}

    socket = io.connect(socketServer)

    socketService.emit = (event, data) ->
        socket.emit event, data

    socketService.on = (event, callback) ->
        socket.on event, (data) ->
            $rootScope.$apply ->
                callback data

    socketService
])
