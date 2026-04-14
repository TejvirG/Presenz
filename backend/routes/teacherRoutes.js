import express from "express";
import { 
  getTeacherClasses, 
  setClassLocation, 
  createClass 
} from "../controllers/teacherController.js";

const router = express.Router();

// All routes made public
router.get("/classes", getTeacherClasses);
router.post("/classes", createClass);
router.post("/classes/:id/location", setClassLocation);
export default router;
