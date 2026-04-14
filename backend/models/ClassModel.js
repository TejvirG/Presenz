import mongoose from "mongoose";

const classSchema = new mongoose.Schema({
  subject: {
    type: String,
    required: true
  },
  semester: {
    type: String,
    required: true
  },
  teacher: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  studentsCount: {
    type: Number,
    default: 0
  },
  latitude: {
    type: Number,
    default: null
  },
  longitude: {
    type: Number,
    default: null
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Class = mongoose.models.Class || mongoose.model("Class", classSchema);
export default Class;