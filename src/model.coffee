_ = require("underscore")
bindable = require("bindable")
Transformers = require("./transformers")
isa = require "isa"

module.exports = class Model extends bindable.Object

  ###
  ###

  constructor: (data = {}, options = {}) ->
    super data
    _.extend @, options

    @init()

  ###
  ###

  init: () ->
    @builder.initModel @
    

  ###
  ###

  transform: (key, transformer) -> 
    transformer = @_transformer().use key, transformer
  ###
  ###

  validate: (callback) ->
    return callback() if not @schema
    @schema.test @, callback

  ###
  ###

  get: (key) ->
    return super key if arguments.length is 0

    if @_virtual[key]
      return @_virtual[key].call(@)

    super key

  ###
  ###

  _set: (key, value) ->

    if @_virtual[key]
      return @_virtual[key].call(@, value)

    super key, @_transform key, value


  ###
  ###

  _transform: (key, value) ->
    return value if not @__transformer
    return @__transformer.set(key, value)

  ###
  ###

  _transformer: () ->
    @__transformer || (@__transformer = new Transformers(@))





