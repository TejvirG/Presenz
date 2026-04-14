import mongoose from "mongoose";

const notificationSchema = new mongoose.Schema(
  {
    message: { type: String, required: true },
    role: { type: String, enum: ["student", "teacher", "admin", "all"], default: "all" },
    createdAt: { type: Date, default: Date.now }
  },
  { timestamps: true }
);

const Notification = mongoose.models.Notification || mongoose.model("Notification", notificationSchema);
export default Notification;
