mongoose = require 'mongoose'

###
    Scene
###

SceneSchema = new mongoose.Schema(
    name: String
    desc: String
    x3d: String
    sourceUrl: String
    created_at:
        type: Date
        default: Date.now
    cached_at:
        type: Date
    copied_from:
        type: mongoose.Schema.Types.ObjectId
        ref: 'Scene'
    public:
        type: Boolean
        required: true
        default: false
)

Scene = mongoose.model 'Scene', SceneSchema
Scene.formage =
    list: ['name', 'created_at', 'public', 'sourceUrl']
    search: ['name', 'desc', 'sourceUrl']
    order_by: ['-created_at']

module.exports.Scene = Scene


###
    User
###

UserSchema = new mongoose.Schema(
    identifier: String  # e.g. https://www.google.com/accounts/o8/id?id=AIt...Oawk
    name: String  # nickname? or warn about public?
    email: String
    created_at:
        type: Date
        default: Date.now
    last_login: Date
)

User = mongoose.model 'User', UserSchema
User.formage =
    list: ['email', 'created_at', 'last_login']

module.exports.User = User
