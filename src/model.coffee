_ = require("underscore")
Bindable = require("bindable")

module.exports = class Model extends Bindable

  ###
  ###

  constructor: (@data, options = {}) ->
    _.extend @, options

  ###
  ###

  validate: (callback) ->
    @schema.test @data, callback

