import express from "express";
import { protect } from "../middleware/authMiddleware.js";
import { registerFace, verifyFace } from "../controllers/faceController.js";

const router = express.Router();
router.post("/register", registerFace);
router.post("/verify", verifyFace);
export default router;