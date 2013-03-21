utils = require "./utils"
async = require "async"
PropertyDefinition = require "./propertyDefinition"

module.exports = class Schema

  ###
  ###

  __isSchema: true

  ###
  ###

  constructor: (@definition, @options) ->
    @build()

  ###
   validates an object against all definitions
  ###

  test: (target, next) ->
    async.forEach @definitions, ((definition, next) ->
      definition.test target, next
    ), next


  ###
   synonym for test
  ###

  validate: (target, next) -> @test target, next

  ###
  ###

  build: () ->
    flattenedDefinitions = utils.flattenDefinitions @definition

    @definitions = []
    for key of flattenedDefinitions
      @definitions.push new PropertyDefinition @, key, flattenedDefinitions[key]


