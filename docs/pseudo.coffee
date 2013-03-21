
###
 Schema definition
###

hobbySchema = new Schema

  name: "string",
  type: "string"




personSchema = new Schema
  
  name: {
    first: "string",
    last: "string"
  },

  phoneNumber: {
    $type: "string",
    $required: true
  },

  createdAt: {
    $type: "date",
    $default: Date.now
  },

  hobbies: [hobbySchema]


###
 person definition
###

class Person extends Model


  ###
  ###

  schema: personSchema




Person.pre "save", (next) ->
  remote.save(this, next)



###
 create the server
###

person = new Person({
  name: {
    first: "craig",
    last: "string"
  }
});


person.validate (error) ->
  console.log(error); //phone number must be present



