import mongoose from "mongoose";

export const connectDB = async () => {
  const { connection } = await mongoose.connect(
    "mongodb+srv://username:pass@cluster0.b7y0h.mongodb.net/?retryWrites=true&w=majority&appName=cluster0"
  );
  console.log(`Mongo connected with ${connection.host}`);
};
