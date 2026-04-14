import express from "express";
import { getReports } from "../controllers/adminController.js";

const router = express.Router();
// Root info for admin routes (public)
router.get("/", (req, res) => {
	res.json({
		message: "Admin endpoints",
		endpoints: {
			reports: "/api/admin/reports (GET)"
		}
	});
});
router.get("/reports", getReports);
export default router;
