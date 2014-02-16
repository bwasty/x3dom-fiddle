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

# for formage
app.use(express.methodOverride())
app.use(express.cookieParser('magical secret admin'))
app.use(express.cookieSession({cookie: { maxAge: 1000 * 60 * 60 *  24 }}))

# mongoose
#mongoose = require 'mongoose'
#app.set 'storage-uri',
#    process.env.MONGOLAB_URI or
#    'mongodb://localhost/scenes'
#
#mongoose.connect app.get('storage-uri'), { db: { safe: true }}, (err) ->
#    console.log "Mongoose - connection error: " + err if err?
#    console.log "Mongoose - connection OK"


# TODO!: test/use
#mongoose = require 'mongoose'
#Grid = require 'gridfs-stream'
#
#conn = mongoose.createConnection app.get('storage-uri')
#conn.once 'open', ->
#    gfs = Grid(conn.db, mongoose.mongo)


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
scenes = require '../models/scene'
#app.post    '/scenes',     scenes.create
#app.get     '/scenes',     scenes.retrieve
#app.get     '/scenes/:id', scenes.retrieve
#app.put     '/scenes/:id', scenes.update
#app.delete  '/scenes/:id', scenes.delete

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

# Angoose bootstraping
require "angoose"
    .init(app,
        'mongo-opts': process.env.MONGOLAB_URI or 'mongodb://localhost/scenes'
    )

# TODO!: integrate in a useful place (working)
#sendgrid = require('sendgrid')(
#    process.env.SENDGRID_USERNAME,
#    process.env.SENDGRID_PASSWORD
#)
#sendgrid.send({
#    to:       'benjamin.wasty@gmail.com',
#    from:     'benny.wasty@gmail.com',
#    subject:  'Hello World',
#    text:     'My first email through SendGrid.'
#}, (err, json) ->
#    console.error err if err
#    console.log json
#)

admin = require('formage').init(app, express, {Scene: scenes},
    title: 'Admin',
    root: '/admin',
    username: 'admin'
    password: 'narak'
    admin_users_gui: true
)

###
  Export server
###
module.exports = server
