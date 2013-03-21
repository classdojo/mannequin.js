schemas = require("./helpers/schemas"),
expect = require("expect.js"),
fixture = require("./helpers/fixture");

describe("schema", function() {

  var personSchema = schemas.personSchema, 
  locationSchema = schemas.locationSchema;

  var model = fixture;

  it("can validate an object & succeed", function(next) {
    personSchema.test(model, next);
  });

  it("createdAt exists", function() {
    expect(model.createdAt).not.to.be(undefined);
  })


  it("can validate an object & fail", function(next) {

    model.location.zip = "9412";

    personSchema.test(model, function(err) {
      expect(err).not.to.be(null);
      expect(err.message).to.contain("location")
      model.location.zip = "94102";
      next();
    });
  });


  it("can fail at email validation (404)", function(next) {
    delete model.email;
    personSchema.test(model, function(err) {
      expect(err).not.to.be(null);
      expect(err.message).to.contain("email")
      next();
    });
  });

})