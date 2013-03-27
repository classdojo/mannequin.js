hoist = require "hoist"

module.exports = class

  ###
  ###

  constructor: (@_transformers, @key) ->
    @_hoister = hoist()

  ###
  ###

  default: (value) ->
    return @_defaultValue if not arguments.length
    @_defaultValue = value
    @

  ###
  ###

  cast: (clazz) ->
    @_hoister.cast clazz

  ###
  ###

  map: (mapper) ->
    @_hoister.map mapper

  ###
  ###

  reset: () ->
    m = @_transformers.model
    m.set @key, @set m.get @key

  ###
  ###

  set: (value) -> 
    @_hoister value or @_defaultValue