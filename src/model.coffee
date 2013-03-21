_ = require("underscore")

module.exports = class Model

  ###
  ###

  constructor: (@data, options = {}) ->
    _.extend @, options


  ###
  ###

  validate: (callback) ->
    @schema.test @data, callback

