
var Schema = require("../../").Schema,
dictionary = require("../../").dictionary();

var locationSchema = new Schema({
  "public name": "string",
  "public state": "string",
  "public zip": { $type: "string", $is: /\d{5}/ }
});


var personSchema = new Schema({
  name: {
    first: "string",
    last: "string"
  },
  email: { 
    $type: "email",
    $required: true
  },
  location: { $ref: "location" },
  createdAt: {
    $type: "date",
    $default: Date.now
  }
});



exports.LocationModel = dictionary.register("location", locationSchema).getClass();
exports.PersonModel   = dictionary.register("person", personSchema).getClass();

