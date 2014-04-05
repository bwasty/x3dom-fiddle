mongoose = require 'mongoose'

Scene = new mongoose.Schema(
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

scene = module.exports = mongoose.model 'Scene', Scene

scene.formage =
    list: ['name', 'created_at', 'public', 'sourceUrl']
    search: ['name', 'desc', 'sourceUrl']
    order_by: ['-created_at']
