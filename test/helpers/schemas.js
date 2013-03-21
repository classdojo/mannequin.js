var Schema = require("../../").Schema;

exports.locationSchema = new Schema({
  name: "string",
  state: "string",
  zip: { $type: "string", $is: /\d{5}/ }
});

exports.personSchema = new Schema({
  name: {
    first: "string",
    last: "string"
  },
  email: { 
    $type: "email",
    $required: true
  },
  location: exports.locationSchema,
  createdAt: {
    $type: "date",
    $default: Date.now
  }
});