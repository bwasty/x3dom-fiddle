###
  Module dependencies.
###

config = require "./config"
express = require "express"
path = require "path"
routes = require "./routes"
sass = require "node-sass"

app = express()

###
  Configuration
###

app.configure "development", "testing", "production", ->
    return config.setEnv app.settings.env
    # TODO!: wtf?
    app.use sass.middleware src: config.STYLES_SRC, dest: config.STYLES_OUT, debug: true

app.set "ipaddr", config.HOSTNAME
app.set "port", process.env.PORT or config.PORT
app.set "views", path.join process.cwd(), config.VIEWS_PATH
app.set "view engine", config.VIEWS_ENGINE
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.favicon("#{process.cwd()}/#{config.PUBLIC_PATH}/#{config.IMAGES_PATH}/favicon.ico")
app.use express["static"] path.join process.cwd(), config.PUBLIC_PATH

# mongoose
mongoose = require 'mongoose'
app.set 'storage-uri',
    process.env.MONGOLAB_URI or
    'mongodb://localhost/scenes'

mongoose.connect app.get('storage-uri'), { db: { safe: true }}, (err) ->
    console.log "Mongoose - connection error: " + err if err?
    console.log "Mongoose - connection OK"

require './services/scene'

###
  Routes config
###

# Views
app.get "/", routes.index
app.get "/x3d", routes.x3d
app.get "/partials/:name", routes.partials

# Services
users = require "./services/users"
app.get "/users", users.list
app.get "/users/:id", users.get

# Scene
scenes = require './services/scene'
app.post    '/scenes',     scenes.create
app.get     '/scenes',     scenes.retrieve
app.get     '/scenes/:id', scenes.retrieve
app.put     '/scenes/:id', scenes.update
app.delete  '/scenes/:id', scenes.delete

###
  Server startup
###

#serverStarted = ->
#    console.log "Server listening on http://#{app.get "ipaddr"}:#{app.get "port"}"

server = app.listen app.get('port'), ->
    console.log("Listening on " + app.get('port'));

###
  Socket.IO registration and configuration
###

io = require("socket.io").listen server
require("./socket").configure io

###
  Export server
###

module.exports = server
