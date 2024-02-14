import mongoose from "mongoose";

export const connectDB = async () => {
  const { connection } = await mongoose.connect(
    "mongodb+srv://Adii:adii@cluster0.k1qcamf.mongodb.net/?retryWrites=true&w=majority"
  );
  console.log(`Mongo connected with ${connection.host}`);
};
