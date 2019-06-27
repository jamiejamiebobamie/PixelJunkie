const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const Populate = require("../utils/autopopulate");
var uniqueValidator = require('mongoose-unique-validator');

const PictureSchema = new Schema({
  name: { type: String }, // for developer reference
  title: { type: String }, // player voted on, NOT IMPLEMENTED
  percentRevealed : { type: Number }, // percent of pixels of the picture owned/revealed
  pixels: [{ type: Schema.Types.ObjectId, ref: "Pixel" }], // array of references to the Pixel objects contained by the picture
  owners: [{ type: Schema.Types.ObjectId, ref: "User" }], // array of references to the User objects that own pixel(s)
});

module.exports = mongoose.model("Picture", PictureSchema);
