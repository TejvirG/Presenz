import express from "express";
import {
  markAttendance,
  getStudentAttendance,
  getClassAttendance
} from "../controllers/attendanceController.js";
import { protect } from "../middleware/authMiddleware.js";

const router = express.Router();
// Root info for attendance routes (public)
router.get("/", (req, res) => {
  res.json({
    message: "Attendance endpoints",
    endpoints: {
      mark: "/api/attendance/mark (POST)",
      studentMe: "/api/attendance/student/me (GET)",
      classAttendance: "/api/attendance/class/:id (GET)"
    }
  });
});
router.post("/mark", markAttendance);
router.get("/student/me", getStudentAttendance);
router.get("/class/:id", getClassAttendance);
export default router;
