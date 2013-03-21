_ = require("underscore")
Bindable = require("bindable")

module.exports = class Model extends Bindable

  ###
  ###

  constructor: (@data = {}, options = {}) ->
    super @data
    _.extend @, options

  ###
  ###

  validate: (callback) ->
    return callback() if not @schema
    @schema.test @data, callback

