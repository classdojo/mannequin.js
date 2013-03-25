_ = require "underscore"
toarray = require "toarray"
async = require "async"
step = require "stepc"
Model = require "./model"


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
      return @_set.apply context, value

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

  ###
  ###

  pre: (keys, callback) -> @_registerPrePost "pre", keys, callback

  ###
  ###

  post: (key, callback) -> @_registerPrePost "post", keys,  callback

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
    @getClass()._virtual[key] or (@getClass()._virtual[key] = new Virtual(key))

  ###
  ###

  getClass: () ->
    if @_class
      return @_class



    clazz = @_class = () ->
      clazz.__super__.constructor.apply(this, arguments);


    @_class.prototype = _.extend({}, Model.prototype)
    @_class.prototype.schema   = @schema
    @_class.prototype.constructor = clazz
    @_class.__super__ = Model.prototype
    @_class.prototype.builder  = @
    @_class.prototype.dictionary  = @dictionary
    @_class.prototype._pre     = {}
    @_class.prototype._post    = {}
    @_class.prototype._virtual = {}
    @_class

  ###
  ###

  _registerPrePost: (pp, keys, callback) ->
    for key in toarray(keys)
      stack = @_prePost(pp, key).push callback

  ###
  ###

  _prePost: (pp, key) ->
    return @_class.prototype[pp]?[key] if @_class.prototype[pp]?[key]

    @_class.prototype._pre[key]  = []
    @_class.prototype._post[key] = []


    original = @_class.prototye[pp]

    @_class.prototype[pp] = (next) ->
      o = outcome.e next

      self = @

      # pre
      step.async (() ->
        async.eachSeries self._pre, ((fn, next) ->
          fn.call self, next
        ), @
      ),

      # original
      (o.s () ->
        return @() if not original
        original.call @
      ), 

      # post
      (o.s () ->
        async.eachSeries self._post, ((fn, next) ->
          fn.call self, next
        ), @
      ), 

      # done
      next


    @_prePost pp, key


