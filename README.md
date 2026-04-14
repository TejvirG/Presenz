# Presenz

Presenz is a full-stack attendance management system with a Flutter frontend and a Node.js/Express backend. It supports teacher/admin authentication, attendance capture, notifications, and face-based attendance workflows.

## Repository Structure

- `backend/` — Node.js backend, Express API, MongoDB data models, authentication, attendance, notifications.
- `frontend/` — Flutter app targeting mobile and desktop/web platforms.
- `setup_fullstack.bat` / `setup_fullstack.sh` — helper scripts for environment setup.

## Features

- User authentication and role-based access
- Attendance recording and reporting
- Notifications management
- Face detection/recognition integration
- Sample data seeding for quick testing

## Prerequisites

- Node.js 18+ and npm
- MongoDB instance or MongoDB Atlas URI
- Flutter SDK
- Android/iOS tooling for native builds
- Git

## Backend Setup

1. Open a terminal in `backend/`
2. Run `npm install`
3. Create a `.env` file with:
   - `MONGO_URI=<your-mongodb-connection-string>`
   - `PORT=10000` (optional)
4. Run the server:
   - `npm run dev` for development
   - `npm start` for production

## Frontend Setup

1. Open a terminal in `frontend/`
2. Run `flutter pub get`
3. Run the app:
   - `flutter run`

The frontend is configured to consume the backend API via `frontend/lib/utils/api_config.dart`.

## Notes

- The backend requires `MONGO_URI` to be set in `.env`.
- The frontend currently points to a deployed backend API base URL, but you can update the URL in `frontend/lib/utils/api_config.dart` for local development.
- Make sure the backend is reachable from the device/emulator running the Flutter app.

## Submission

This repository is prepared for submission with project documentation, source structure, and setup instructions.
