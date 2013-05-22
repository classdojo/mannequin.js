Transformer = require "./transformer"



module.exports = class

  ###
  ###

  constructor: (@model) ->  
    @_transformers = {}

  ###
  ###
  

  set: (key, value) ->
    target = { key: key, currentValue: value }

    for transformer in @_findTransformers(key, false)
      transformer(target)

    target.currentValue


  ###
  ###

  _findTransformers: (key, create = true) ->
    keyParts = key.split(".")
    endKey = keyParts[keyParts.length - 1]

    for part in keyParts
      if not @_transformers[part]
        return [] if not create

      @_transformers[part] = @_transformers[part] or {}

    if not @_transformers[endKey]._items
      @_transformers[endKey]._items = []

    @_transformers[endKey]._items or []


  use: (key) -> 


    transformer = new Transformer @, key


      


    @_findTransformers(key, true).push (target) =>
      return if target.key isnt key
      if not key or (@model.get(key) isnt target.currentValue)
        target.currentValue = transformer.set target.currentValue


    transformer
