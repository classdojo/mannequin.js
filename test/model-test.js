var models = require("./helpers/models"),
PersonModel = models.PersonModel,
LocationModel = models.LocationModel,
fixture = require("./helpers/fixture");

describe("models", function() {


  var person, location;

  it("can create a model", function() {
    person = new PersonModel(fixture)
  });

  it("can validate a model successfuly", function(next) {
    person.validate(next);
  })
});