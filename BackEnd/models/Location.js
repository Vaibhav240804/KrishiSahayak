import mongoose from "mongoose"

const locationSchema = new mongoose.Schema({
    latitude: Number,
    longitude: Number,
    city: String,
    state: String,
    pincode: String,
    address: String,
  });

  
export const Location = mongoose.model("Location", locationSchema);
