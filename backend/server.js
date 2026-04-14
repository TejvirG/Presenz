import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import connectDB from "./config/db.js";
import authRoutes from "./routes/authRoutes.js";
import { registerUser, loginUser } from "./controllers/authController.js";
import teacherRoutes from "./routes/teacherRoutes.js";
import attendanceRoutes from "./routes/attendanceRoutes.js";
import adminRoutes from "./routes/adminRoutes.js";
import notificationsRoutes from "./routes/notificationsRoutes.js";

// Load environment variables first
dotenv.config();

// Validate essential environment variables
if (!process.env.MONGO_URI) {
  console.error('❌ MONGO_URI environment variable is not set');
  process.exit(1);
}

const app = express();

// Basic middleware
app.use(cors());
app.use(express.json({
  limit: '10mb',
  verify: (req, res, buf) => {
    req.rawBody = buf;
  }
}));

// Error handling for JSON parsing
app.use((err, req, res, next) => {
  if (err instanceof SyntaxError && err.status === 400 && 'body' in err) {
    return res.status(400).json({ 
      error: 'Invalid JSON payload',
      details: err.message 
    });
  }
  next();
});

// Initialize database connection
connectDB();

// Debug: echo endpoint to verify POST connectivity and JSON parsing
app.post('/debug/echo', (req, res) => {
	console.log('debug/echo body:', req.body);
	res.json({ ok: true, body: req.body });
});

// Health check
app.get("/", (req, res) => res.send("Presenz backend running ✅"));

// API root - helpful for clients checking base /api path
app.get("/api", (req, res) => {
	res.json({
		message: "Presenz API",
		endpoints: {
			auth: {
				base: "/api/auth",
				signup: "/api/auth/signup",
				login: "/api/auth/login"
			},
			teacher: "/api/teacher",
			attendance: "/api/attendance",
			admin: "/api/admin",
			notifications: "/api/notifications"
		}
	});
});
// Health endpoint for monitoring
app.get("/api/health", (req, res) => {
	res.json({ status: "ok", uptime: process.uptime() });
});

// Mount routes - auth routes first to ensure they take precedence
app.use("/api/auth", authRoutes);
app.use("/api/teacher", teacherRoutes);
app.use("/api/attendance", attendanceRoutes);
app.use("/api/admin", adminRoutes);
app.use("/api/notifications", notificationsRoutes);

// Catch-all
app.use((req, res) => res.status(404).json({ error: "Route not found" }));

const PORT = process.env.PORT || 10000;

// Set up graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  server.close(() => {
    console.log('HTTP server closed');
    mongoose.connection.close(false, () => {
      console.log('MongoDB connection closed');
      process.exit(0);
    });
  });
});

// Create HTTP server
const server = app.listen(PORT, () => {
  // Print startup banner
  console.log('\n--------------------------------------------------');
  console.log(`⚡️ Server Status`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'production'}`);
  console.log(`🚀 Server: http://0.0.0.0:${PORT}`);
  console.log(`📚 Database: ${process.env.MONGO_URI ? 'MongoDB configured' : 'MongoDB not configured'}`);
  console.log(`\n🔑 Core Endpoints:`);
  console.log(`   GET  /api/health    - Health check`);
  console.log(`   POST /api/auth/signup - User registration`);
  console.log(`   POST /api/auth/login  - User authentication`);
  console.log('--------------------------------------------------\n');

  // Print all mounted routes for debugging
  try {
    const routes = [];
    app._router.stack.forEach((middleware) => {
      if (middleware.route) {
        // Direct routes
        const methods = Object.keys(middleware.route.methods)
          .map(m => m.toUpperCase().padEnd(6))
          .join(',');
        routes.push(`${methods} ${middleware.route.path}`);
      } else if (middleware.name === 'router' && middleware.handle.stack) {
        // Router middleware
        middleware.handle.stack.forEach((handler) => {
          if (handler.route) {
            const methods = Object.keys(handler.route.methods)
              .map(m => m.toUpperCase().padEnd(6))
              .join(',');
            const path = handler.route.path;
            if (middleware.regexp) {
              // Add the parent path if available
              const parentPath = middleware.regexp.source
                .replace('^\\\/?', '')
                .replace('(?=\\/|$)', '')
                .replace(/\\\//g, '/');
              routes.push(`${methods} ${parentPath}${path}`);
            } else {
              routes.push(`${methods} ${path}`);
            }
          }
        });
      }
    });

    console.log('📋 Mounted Routes:');
    routes.sort().forEach(r => console.log(`   ${r}`));
    console.log('--------------------------------------------------\n');
  } catch (err) {
    console.error('❌ Failed to list routes:', err);
  }
});