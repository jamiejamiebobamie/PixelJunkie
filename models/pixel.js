const mongoose = require("mongoose");
const Schema = mongoose.Schema;
const Populate = require("../utils/autopopulate");
var uniqueValidator = require('mongoose-unique-validator');


const PixelSchema = new Schema({
    coordinateX: { type: Number }, // coordinate in picture :: width or x value
    coordinateY: { type: Number }, // coordinate in picture :: height or y value
    hexCode: { type: String }, // the color or hex code of the pixel
    percentRevealed : { type: Number }, // percent of pixels of the picture owned/revealed
    picture: { type: Schema.Types.ObjectId, ref: "Pixel" }, // array of references to the Pixel objects contained by the picture
    owner: { type: Schema.Types.ObjectId, ref: "User" }, // array of references to the User objects that own pixel(s)
});

// // Always populate the author field
// StockSchema
//     .pre('findOne', Populate('quote'))
//     .pre('find', Populate('quote'))

module.exports = mongoose.model("Pixel", PixelSchema);
