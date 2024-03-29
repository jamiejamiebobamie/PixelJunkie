const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const Schema = mongoose.Schema;
const uniqueValidator = require('mongoose-unique-validator');


const UserSchema = new Schema({
  password: { type: String, select: false },
  username: { type: String, required: true, unique: true },
  pixels : [{ type: Schema.Types.ObjectId, ref: "Pixel" }],
  pictures : [{ type: Schema.Types.ObjectId, ref: "Picture" }],
});


UserSchema.pre("save", function(next) {
  const now = new Date();
  this.updatedAt = now;
  if (!this.createdAt) {
    this.createdAt = now;
  }

  // ENCRYPT PASSWORD
  const user = this;
  if (!user.isModified("password")) {
    return next();
  }
  bcrypt.genSalt(10, (err, salt) => {
    bcrypt.hash(user.password, salt, (err, hash) => {
      user.password = hash;
      next();
    });
  });
});

// Need to use function to enable this.password to work.
UserSchema.methods.comparePassword = function(password, done) {
  bcrypt.compare(password, this.password, (err, isMatch) => {
    done(err, isMatch);
  });
};

module.exports = mongoose.model("User", UserSchema);
