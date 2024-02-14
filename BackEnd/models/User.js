import mongoose from "mongoose";
import validator from "validator";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";

const toDoListSchema = new mongoose.Schema({
  task: {
    type: String,
    enum: [
      "Sowing",
      "Picking",
      "Growing and Harvesting Crops",
      "Cattle hospitality",
      "Soil testing",
      "Equipment buying",
      "Equipment servicing",
      "Feeding livestock",
      "Other",
    ],
    required: true,
  },
  otherTask: {
    type: String,
  },
  dateTime: {
    type: Date,
    required: true,
  },
});

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "Please enter your name"],
  },
  email: {
    type: String,
    required: [true, "Please enter your email"],
    unique: true,
    validate: validator.isEmail,
  },

  password: {
    type: String,
    required: [true, "Please enter your password"],
    select: false,
  },
  location: [
    {
      latitude: { type: Number, required: true },
      longitude: { type: Number, required: true },
      city: { type: String, required: true },
      state: { type: String, required: true },
      pincode: { type: String, required: true },
      address: { type: String, required: true },
    },
  ],
  SoilComposition: [
    {
      nLevel: { type: Number },
      pLevel: { type: Number },
      kLevel: { type: Number },
      temperature: { type: Number },
      humidity: { type: Number },
      phLevel: { type: Number },
      rainfall: { type: Number },
    },
  ],
  todolist: [toDoListSchema],
});

userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 10);
  console.log("Hashed Password:", this.password);
  next();
});

userSchema.methods.getJWTToken = function () {
  console.log(process.env.JWT_SECRET);
  return jwt.sign({ _id: this._id }, process.env.JWT_SECRET, {
    expiresIn: "15d",
  });
};

userSchema.methods.comparePassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};

export const User = mongoose.model("User", userSchema);
