var models = require("./helpers/models"),
PersonModel = models.PersonModel,
LocationModel = models.LocationModel,
fixture = require("./helpers/fixture"),
expect = require("expect.js");

describe("models", function() {


  var person, location;

  it("can create a model", function() {
    person = new PersonModel(fixture);
  });

  it("has a schema", function() {
    expect(person.schema).not.to.be(undefined);
  })

  it("can validate a model successfuly", function(next) {
    person.validate(next);
  });

  it("can set the location zip", function() {
    person.set("location.zip", "4355");
    expect(person.get("location.zip")).to.be("4355");
  });

  it("can validate the location zip", function(next) {
    person.validate(function(err) {
      expect(err).not.to.be(undefined);
      expect(err.message).to.contain("location");
      next();
    });
  });

  it("can reset the zip and succeed", function(next) {
    person.set("location.zip", "90222");
    person.validate(next);
  });

  it("location is type casted as a location model", function() {
    expect(person.get("location").builder.name).to.be("location");
  });
  
});