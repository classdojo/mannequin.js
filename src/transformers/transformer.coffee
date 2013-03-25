__getClass = (object) ->
  return Object.prototype.toString.call(object)
    .match(/^\[object\s(.*)\]$/)[1];


module.exports = class

  ###
  ###

  constructor: (@_transformers, @key, @_transform) ->

  ###
  ###

  default: (value) ->
    return @_defaultValue if not arguments.length
    @_defaultValue = value
    @

  ###
  ###

  cast: (clazz) ->
    @_transform = (value) =>
      return @_defaultValue if not value
      return value if value.constructor is clazz
      return new clazz(value)
    @


  ###
  ###

  reset: () ->
    m = @_transformers.model
    m.set @key, @set m.get @key


  ###
  ###

  set: (value) -> 
    @_transform value or @_defaultValue




