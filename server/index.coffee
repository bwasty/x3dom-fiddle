###
  Module dependencies.
###

config = require "./config"
express = require "express"
path = require "path"
routes = require "./routes"
sass = require "node-sass"
passport = require 'passport'
GoogleStrategy = require('passport-google').Strategy

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
app.use express.compress()
app.use express.bodyParser()
app.use express.methodOverride()
app.use passport.initialize()
app.use passport.session()
app.use app.router
app.use express.favicon("#{process.cwd()}/#{config.PUBLIC_PATH}/#{config.IMAGES_PATH}/favicon.ico")

app.use express.static path.join(process.cwd(), config.PUBLIC_PATH)

if process.env.NODE_ENV != 'production'
    app.use express.static path.join(process.cwd(), 'client')
    app.set 'dev', true
    returnURL = "http://localhost:8080/auth/google/return"
    realm: "http://localhost:8080/"
else
    returnURL = "http://x3dom.malkut.de/auth/google/return"
    realm = "http://x3dom.malkut.de/"

# for formage
app.use(express.cookieParser('magical secret admin'))
app.use(express.cookieSession({cookie: { maxAge: 7 * 60 * 60 * 24 }}))

###
google auth
###

# Passport session setup.
#   To support persistent login sessions, Passport needs to be able to
#   serialize users into and deserialize users out of the session.  Typically,
#   this will be as simple as storing the user ID when serializing, and finding
#   the user by ID when deserializing.  However, since this example does not
#   have a database of user records, the complete Google profile is serialized
#   and deserialized.
passport.serializeUser (user, done) ->
    done null, user
    return

passport.deserializeUser (obj, done) ->
    done null, obj
    return

# Use the GoogleStrategy within Passport.
#   Strategies in passport require a `validate` function, which accept
#   credentials (in this case, an OpenID identifier and profile), and invoke a
#   callback with a user object.
passport.use new GoogleStrategy(
    # TODO!: local/prod switch...
    returnURL: returnURL
    realm: realm
, (identifier, profile, done) ->
    console.log identifier
    console.log profile

    # asynchronous verification, for effect...
#    process.nextTick ->

    # To keep the example simple, the user's Google profile is returned to
    # represent the logged-in user.  In a typical application, you would want
    # to associate the Google account with a user record in your database,
    # and return that user instead.
    profile.identifier = identifier
    done null, profile
)

# Simple route middleware to ensure user is authenticated.
#   Use this route middleware on any resource that needs to be protected.  If
#   the request is authenticated (typically via a persistent login session),
#   the request will proceed.  Otherwise, the user will be redirected to the
#   login page.
ensureAuthenticated = (req, res, next) ->
    return next()  if req.isAuthenticated()
    res.redirect "/login"

app.get "/account", ensureAuthenticated, (req, res) ->
    res.render "account",
        user: req.user

app.get "/login", (req, res) ->
    res.render "login",
        user: req.user

# GET /auth/google
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  The first step in Google authentication will involve redirecting
#   the user to google.com.  After authenticating, Google will redirect the
#   user back to this application at /auth/google/return
app.get "/auth/google", passport.authenticate("google", {failureRedirect: "/login"}), (req, res) ->
    res.redirect "/"

# GET /auth/google/return
#   Use passport.authenticate() as route middleware to authenticate the
#   request.  If authentication fails, the user will be redirected back to the
#   login page.  Otherwise, the primary route function function will be called,
#   which, in this example, will redirect the user to the home page.
app.get "/auth/google/return", passport.authenticate("google",
    failureRedirect: "/login"
), (req, res) ->
#    res.redirect "/"
    console.log(req.user)
    res.render "index", dev: req.app.get('dev'), user: req.user

app.get "/logout", (req, res) ->
    req.logout()
    res.redirect "/"


# mongoose
mongoose = require 'mongoose'
app.set 'storage-uri',
    process.env.MONGOLAB_URI or
    'mongodb://localhost/scenes'

mongoose.connect app.get('storage-uri'), { db: { safe: true }}, (err) ->
    if err?
        console.log "Mongoose - connection error: " + err
    else
        console.log "Mongoose - connection OK"


# TODO!: test/use
#mongoose = require 'mongoose'
#Grid = require 'gridfs-stream'
#
#conn = mongoose.createConnection app.get('storage-uri')
#conn.once 'open', ->
#    gfs = Grid(conn.db, mongoose.mongo)

# angular-bridge
models = require './models'

angularBridge = new (require('angular-bridge'))(app, {
    urlPrefix : '/api/'
})

# With express you can password protect a url prefix :
#app.use('/api', express.basicAuth('admin', 'my_password'));

# Expose the collection via REST
angularBridge.addResource('scenes', models.Scene);


###
  Routes config
###

# Views
app.get "/", routes.index
app.get "/x3d", routes.x3d
app.get "/partials/:name", routes.partials

###
  Server startup
###

server = app.listen app.get('port'), ->
    console.log("Listening on " + app.get('port'));

###
  Socket.IO registration and configuration
###

io = require("socket.io").listen server
require("./socket").configure io

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

admin = require('formage').init(app, express, models,
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
