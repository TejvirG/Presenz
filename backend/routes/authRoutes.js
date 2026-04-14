import express from "express";
import { registerUser, loginUser } from "../controllers/authController.js";

const router = express.Router();

// Public info for auth routes
router.get("/", (req, res) => {
    res.json({
        message: "Auth endpoints",
        endpoints: {
            signup: "/api/auth/signup (POST)",
            login: "/api/auth/login (POST)"
        }
    });
});

// Core auth endpoints
router.post("/signup", async (req, res) => {
    try {
        console.log("Signup request received with body:", req.body);
        await registerUser(req, res);
    } catch (error) {
        console.error("Error in signup route:", error);
        res.status(500).json({ error: "Internal server error", details: error.message });
    }
});

router.post("/login", async (req, res) => {
    try {
        console.log("Login request received with body:", req.body);
        await loginUser(req, res);
    } catch (error) {
        console.error("Error in login route:", error);
        res.status(500).json({ error: "Internal server error", details: error.message });
    }
});

export default router;