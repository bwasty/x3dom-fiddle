mongoose = require 'mongoose'

Scene = new mongoose.Schema(
    name: String
    desc: String
    x3d: String
    sourceUrl: String
    created_at: { type: Date, default: Date.now }
    cached_at: { type: Date, default: null }
    copied_from: { type: mongoose.Schema.Types.ObjectId, ref: 'Scene' }
)

mongoose.model 'Scene', Scene

# controller/scenes.coffee?

exports.create = (req, res) ->
    Resource = mongoose.model('Scene')
    fields = req.body

    r = new Resource(fields)
    r.save (err, resource) ->
        res.send(500, { error: err }) if err?
        res.send(resource)


exports.retrieve = (req, res) ->
    Resource = mongoose.model('Scene')

    if req.params.id?
        Resource.findById req.params.id, (err, resource) ->
            res.send(500, { error: err }) if err?
            res.send(resource) if resource?
            res.send(404)
    else
        Resource.find {}, (err, coll) ->
            res.send(coll)

exports.update = (req, res) ->
    Resource = mongoose.model('Scene')
    fields = req.body

    Resource.findByIdAndUpdate req.params.id, { $set: fields }, (err, resource) ->
        res.send(500, { error: err }) if err?
        res.send(resource) if resource?
        res.send(404)

exports.delete = (req, res) ->
    Resource = mongoose.model('Scene')

    Resource.findByIdAndRemove req.params.id, (err, resource) ->
        res.send(500, { error: err }) if err?
        res.send(200) if resource?
        res.send(404)
