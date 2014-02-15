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
    app.use sass.middleware src: config.STYLES_SRC, dest: config.STYLES_OUT, debug: true

app.set "ipaddr", config.HOSTNAME
app.set "port", config.PORT
app.set "views", path.join process.cwd(), config.VIEWS_PATH
app.set "view engine", config.VIEWS_ENGINE
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router
app.use express.favicon("#{process.cwd()}/#{config.PUBLIC_PATH}/#{config.IMAGES_PATH}/favicon.ico")
app.use express["static"] path.join process.cwd(), config.PUBLIC_PATH

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

###
  Server startup
###

serverStarted = ->
    console.log "Server listening on http://#{app.get "ipaddr"}:#{app.get "port"}"

server = app.listen app.get('port'), app.get('ipaddr'), serverStarted

###
  Socket.IO registration and configuration
###

io = require("socket.io").listen server
require("./socket").configure io

###
  Export server
###

module.exports = server