###
  GET home page
###
exports.index = (request, response) ->
    response.render "index"


exports.x3d = (request, response) ->
    response.render "x3d"

###
  GET partial templates
###
exports.partials = (request, response) ->
    response.render "partials/" + request.params.name