import dotenv from "dotenv";
import mongoose from "mongoose";
import User from "../models/User.js";
import Class from "../models/Class.js";
import connectDB from "../config/db.js";

dotenv.config();
connectDB();

const seedData = async () => {
  try {
    await User.deleteMany();
    await Class.deleteMany();

    const teacher = await User.create({
      name: "John Teacher",
      email: "teacher@example.com",
      password: "123456",
      role: "teacher"
    });

    await Class.create({
      name: "Math 101",
      subject: "Mathematics",
      teacher: teacher._id,
      schedule: { day: "Monday", time: "10:00 AM" },
      subgroups: ["A", "B"]
    });

    console.log("Database seeded successfully");
    process.exit();
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

seedData();
