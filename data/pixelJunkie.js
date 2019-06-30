/* Mongoose Connection */
const mongoose = require("mongoose");
assert = require("assert");

// //heroku database.
// mongoose.connect((process.env.MONGODB_URI || 'mongodb://localhost/database'), { useNewUrlParser: true });

// local host database
// mongoose.connect('mongodb://localhost/pixelJunkie');

const url = "mongodb://localhost/database";
mongoose.Promise = global.Promise;
mongoose.connect(
  "mongodb://localhost/database",
  { useNewUrlParser: true }
);
mongoose.connection.on("error", console.error.bind(console, "MongoDB connection Error:"));
mongoose.set("debug", true);

module.exports = mongoose.connection;
