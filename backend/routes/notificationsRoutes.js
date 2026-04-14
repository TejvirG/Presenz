import express from "express";
import {
  getNotifications,
  createNotification
} from "../controllers/notificationsController.js";

const router = express.Router();
// All routes made public
router.get("/", getNotifications);
router.post("/", createNotification);
export default router;
