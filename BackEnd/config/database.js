import mongoose from "mongoose";

export const connectDB = async () => {
  const { connection } = await mongoose.connect(
    "mongodb+srv://direct2vaibhavkore:GJVn9M2r2F8Ei0oA@db.6yoasr1.mongodb.net/?retryWrites=true&w=majority&appName=db"
  );
  console.log(`Mongo connected with ${connection.host}`);
};
