var schemas = require("./schemas"),
Model = require("../../").Model,
structr = require("structr");


exports.LocationModel = structr(Model, {
  schema: schemas.locationSchema
});

exports.PersonModel = structr(Model, {
  schema: schemas.personSchema
});