dref   = require "dref"
utils  = require "./utils"
verify = require("verify")()
async  = require "async"
toarray = require "toarray"

###
###

class PropertyDefinition
  
  ###
  ###

  constructor: (@schema, @key, definition) ->
    @definition = @_fixDefnition definition

    # make sure the definition is OK
    @_validateDefinition()

    # make the validators for the data type
    @_createValidators()


  ###
  ###

  test: (target, callback) ->

    v = dref.get(target, @key) or @_default()

    if not v and @definition.$required
        return callback new Error "\"#{@key}\" must be present"



    async.forEach @_testers, ((tester, next) ->
      tester v, next
    ), (err) =>
      if err 
        return callback new Error @definition.message or "\"#{@key}\" is invalid"

      dref.set target, @key, v

      callback()


  ###
  ###

  _fixDefnition: (definition) ->

    if typeof definition is "string" or utils.firstKey(definition).substr(0, 1) isnt "$"
      return {
        $type: definition
      }
    else if definition instanceof Array
      return {
        $type: definition[0],
        $multi: true
      }
    else 
      return definition


  ###
  ###

  _validateDefinition: () ->

    if not @definition.$type
      throw new Error "definition type must exist for #{@key}"


  ###
  ###

  _createValidators: () ->  

    testers = []

    if @definition.$multi
      testers.push verify.tester().is("array")


    # type is a schema? 
    if utils.isSchema @definition.$type
      testers.push @_multi @definition.$type

    # type is a string?
    else
      testers.push @_multi @_generateTypeTester()

    # is a tester provided?
    if @definition.$test
      testers.push @_multi @definition.$test

    @_testers = testers


  ###
  ###

  _generateTypeTester: () ->
    tester = verify.tester().is(@definition.$type)

    return null if @definition.$test

    # checks for stuff like { $type: "string", $is: /regexp/ }
    for key of @definition
      k = key.substr(1)
      if !!tester[k]
        tester[k].apply tester, toarray @definition[key]

    tester


  ###
  ###

  _multi: (tester) ->
    tester = @_tester tester
    (value, next) ->
      async.forEach toarray(value), ((value, next) ->
        tester value, next
      ), next

  ###
  ###

  _default: () ->
    return undefined if not @definition.$default
    return @definition.$default() if typeof @definition.$default is "function"
    return @definition.$default

  ###
  ###

  _tester: (target) ->

    context = @
    test    = null

    if typeof target is "function"
      test = target
    else if target.test
      test = target.test
      context = target


    (value, next) ->
      if test.length is 1
        next !test.call context, value
      else
        test.call context, value, next





###
###

module.exports = PropertyDefinition
