import mongoose from "mongoose";

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

export const ToDoSchema = mongoose.model("ToDoSchema", toDoListSchema);
