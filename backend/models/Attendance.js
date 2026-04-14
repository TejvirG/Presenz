import mongoose from "mongoose";

const attendanceSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    classId: { type: mongoose.Schema.Types.ObjectId, ref: "Class", required: true },
    status: { type: String, enum: ["Present", "Absent", "Late"], default: "Present" },
    timestamp: { type: Date, default: Date.now },
    location: {
      latitude: Number,
      longitude: Number
    }
  },
  { timestamps: true }
);

const Attendance = mongoose.models.Attendance || mongoose.model("Attendance", attendanceSchema);
export default Attendance;
