(function (){
  'use strict';

  var client = require("mongodb").MongoClient;
  var url = "mongodb://carts-db:27017/data}";

  var handleErr = function(err) {
    console.log("something went wrong: %s", err.message);
  };

  var count = 0;

  ["cart", "item"].forEach(function(col) {
    client.connect(url, function(err, client) {
      if (err) return handleErr(err);
      client.collection(col).
        remove({}, { w: 1 }, function(err, res) {
        if (err) return handleErr(err);
        client.close();
      });
    });
  });
}());
