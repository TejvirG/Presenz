# Presenz Backend

This folder contains the backend API for Presenz, built with Node.js, Express, and MongoDB.

## Setup

1. Install dependencies:
   ```bash
   cd backend
   npm install
   ```
2. Create `.env` with:
   ```env
   MONGO_URI=<your-mongo-connection-string>
   PORT=10000
   ```
3. Start the backend:
   ```bash
   npm run dev
   ```

## Scripts

- `npm start` — run the server in production mode
- `npm run dev` — run the server with nodemon
- `npm run seed` — seed sample data

## API Endpoints

- `GET /api/health`
- `POST /api/auth/signup`
- `POST /api/auth/login`
- `GET /api/teacher/...`
- `GET /api/attendance/...`
- `GET /api/admin/...`
- `GET /api/notifications/...`
