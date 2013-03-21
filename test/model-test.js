var models = require("./helpers/models"),
PersonModel = models.PersonModel,
LocationModel = models.LocationModel,
fixture = require("./helpers/fixture"),
expect = require("expect.js");

describe("models", function() {


  var person, location;

  it("can create a model", function() {
    person = new PersonModel(fixture)
  });

  it("can validate a model successfuly", function(next) {
    person.validate(next);
  });

  it("can set the zip and fail", function(next) {
    person.set("location.zip", "4355");
    person.validate(function(err) {
      expect(err).not.to.be(undefined);
      expect(err.message).to.contain("location");
      next();
    });
  });

  it("can reset the zip and succeed", function(next) {
    person.set("location.zip", "90222");
    person.validate(next);
  })
});