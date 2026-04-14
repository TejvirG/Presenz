import User from "../models/User.js";
import Attendance from "../models/Attendance.js";
import Class from "../models/Class.js";

export const getReports = async (req, res) => {
  try {
    const totalUsers = await User.countDocuments();
    const totalClasses = await Class.countDocuments();
    const totalAttendance = await Attendance.countDocuments();
    res.json({ totalUsers, totalClasses, totalAttendance });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
