_ = require "underscore"
toarray = require "toarray"
async = require "async"
step = require "stepc"
Model = require "./model"
bindable = require "bindable"
outcome = require "outcome"


class Virtual

  ###
  ###

  __isVirtual: true

  ###
  ###

  constructor: (key) ->  

    @get () -> 
      @[key]

    @set (value) ->
      @[key] = value

  
  ###
  ###

  call: (context, value) =>

    if arguments.length is 1 
      return @_get.call context
    else
      return @_set.call context, value

    @


  ###
  ###

  get: (@_get) -> @


  ###
  ###

  set: (@_set) -> @


module.exports = class ModelBuilder

  ###
  ###

  constructor: (@dictionary, @name, @schema) ->
    @_virtuals = {}
    @_pre = {}
    @_post = {}

    @properties = @methods = @getClass().prototype
    @statics = @getClass()
    @_setupMethods()

  ###
  ###

  pre: (keys, callback) -> @_registerPrePost @_pre, keys, callback

  ###
  ###

  post: (keys, callback) -> @_registerPrePost @_post, keys,  callback

  ###
   registers static vars
  ###

  static: (key, callback) ->

    if arguments.length is 1
      for k of key
        @static k, key[k]
        return

    @getClass()[key] = callback

  ###
   virtual methods for getters
  ###

  virtual: (key) ->
    @_virtuals[key] or (@_virtuals[key] = new Virtual(key))

  ###
  ###

  initModel: (model) ->
    @_initPropertyTransformation model, def for def in @schema.refs()


  ###
  ###

  _initPropertyTransformation: (model, def) ->
    transformer = model.transform def.key

    if def.options.$multi
      @_initCollectionTransformation model, transformer, def
    else
      @_initModelTransformation model, transformer, def

    transformer.reset()

  ###
  ###

  _initCollectionTransformation: (model, transformer, def) ->
      refClass = @dictionary.modelBuilder(def.options.$ref).getClass()

      transformer.map((source) =>
        col = @createCollection def
        
        col.parent = model

        col.transform().cast(refClass).map (item) ->
          item.parent = col
          item.definition = def
          item

        col.reset source
      )

      if not model.get(def.key)
        @_set def.key, []

  ###
  ###

  _initModelTransformation: (model, transformer, def) ->
    refClass = @dictionary.modelBuilder(def.options.$ref).getClass()
    transformer.cast(refClass).map((model) ->
      model.ownerDefinition = def
      model
    )


  ###
  ###

  createCollection: (item) ->
    new bindable.Collection()

  ###
  ###

  getClass: () ->
    if @_class
      return @_class

    clazz = @_class = () ->
      clazz.__super__.constructor.apply(this, arguments);


    @_class.prototype             = _.extend({}, Model.prototype)
    @_class.prototype.schema      = @schema
    @_class.prototype.constructor = clazz
    @_class.__super__             = Model.prototype
    @_class.prototype.builder     = @
    @_class.prototype.dictionary  = @dictionary
    @_class.prototype._pre        = @_pre
    @_class.prototype._post       = @_post
    @_class.prototype._virtual    = @_virtuals
    @_class.builder = @
    @_class

  ###
  ###

  _registerPrePost: (pp, keys, callback) ->
    for key in toarray(keys)
      @_prePost(pp, key).push callback
    @

  ###
  ###

  _setupMethods: () ->
    @methods.model = (name) =>
      @dictionary.modelBuilder(name).getClass()

  ###
  ###

  _prePost: (pp, key) ->
    return pp[key] if pp[key]

    @_pre[key]  = []
    @_post[key] = []

    original = @_class.prototype[key]

    pre = @_pre[key]
    post = @_post[key]

    @_class.prototype[key] = (next) ->
      o = outcome.e next

      self = @

      # pre
      step.async (() ->
        async.eachSeries pre, ((fn, next) ->
          fn.call self, next
        ), @
      ),

      # original
      (o.s () ->
        return @() if not original
        original.call self, @
      ), 

      # post
      (o.s () ->
        async.eachSeries post, ((fn, next) ->
          fn.call self, next
        ), @
      ), 

      # done
      next


    @_prePost pp, key


