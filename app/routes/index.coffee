###
  GET home page
###
exports.index = (request, response) ->
    response.render "index", dev: request.app.get('dev')


exports.x3d = (request, response) ->
    response.render "x3d"

###
  GET partial templates
###
exports.partials = (request, response) ->
    response.render "partials/" + request.params.name
