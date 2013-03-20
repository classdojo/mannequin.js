
###
 Schema definition
###

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
  }


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


person.validate(function(error) {
  console.log(error); //phone number must be present
});


