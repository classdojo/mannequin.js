// Generated by CoffeeScript 1.6.2
(function() {
  var type, _flatten;

  type = require("type-component");

  _flatten = function(target, path, context) {
    var cp, key, kk, v;

    for (key in target) {
      v = target[key];
      cp = path.concat(key);
      kk = cp.join(".");
      if (key.substr(0, 1) === "$") {
        context[path.join(".")] = target;
        return;
      } else if (!v) {
        continue;
      } else if (type(v) === "array") {
        context[kk] = v;
      } else if (type(v) === "object") {
        if (exports.isSchema(v)) {
          context[kk] = v;
        } else {
          _flatten(v, cp.concat(), context);
        }
      } else {
        context[kk] = v;
      }
    }
    return context;
  };

  exports.isSchema = function(target) {
    return !!target && target.__isSchema;
  };

  exports.flattenDefinitions = function(target) {
    return _flatten(target, [], {});
  };

  exports.firstKey = function(target) {
    var k;

    for (k in target) {
      return k;
    }
  };

}).call(this);
