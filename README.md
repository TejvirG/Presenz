# Presenz

Presenz is a professional full-stack attendance management application built for modern academic environments. It combines a polished Flutter frontend with a robust Node.js + Express backend and MongoDB database support.

## Why this project stands out

- Full API-driven architecture with clear route separation
- Secure authentication and role-based access for students, teachers, and admins
- Database design with MongoDB models for users, classes, attendance, and notifications
- Real-time attendance workflows with location and face recognition hooks
- Clean project structure suitable for submission and further extension

## Repository Structure

- `backend/` — complete REST API implementation using Express and MongoDB
- `frontend/` — Flutter application for mobile, desktop, and web targets
- `setup_fullstack.bat` / `setup_fullstack.sh` — environment setup helpers for easy startup

## Core Implementation

### Backend

The backend delivers a full-featured API with:

- Authentication: signup, login, JWT-based protection, role verification
- Database support: MongoDB models, secure password hashing, and connection management
- API endpoints for:
  - user auth and profile (`/api/auth`)
  - teacher workflows (`/api/teacher`)
  - attendance records (`/api/attendance`)
  - admin controls (`/api/admin`)
  - notifications (`/api/notifications`)
- Error handling, health checks, and environment configuration

### Frontend

The Flutter frontend includes:

- Login/signup flows
- Role-specific dashboards for students, teachers, and admins
- Attendance capture, reporting, and history screens
- Notification views and alerts
- Modular service architecture consuming the backend API

## Features

- Authentication and security
- Structured backend API implementation
- MongoDB database integration
- Attendance and reporting workflows
- Notification management
- Face-based attendance support in the app
- Environment-ready setup for local development

## Technology Stack

- Backend: Node.js, Express, MongoDB, Mongoose, JWT, dotenv
- Frontend: Flutter, Dart, HTTP services, responsive UI
- Tools: Git, npm, Flutter SDK, Android/iOS development tooling

## Setup Instructions

### Backend setup

1. Open a terminal in `backend/`
2. Install dependencies:
   ```bash
   npm install
   ```
3. Create a `.env` file with:
   ```env
   MONGO_URI=<your-mongodb-connection-string>
   PORT=10000
   ```
4. Start the backend:
   ```bash
   npm run dev
   ```

### Frontend setup

1. Open a terminal in `frontend/`
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

> The frontend reads the backend base URL from `frontend/lib/utils/api_config.dart`.

## Important Notes

- The backend must be running before the frontend can communicate successfully.
- For local development, update the API base URL in the frontend configuration file.
- Sensitive files such as `.env` are excluded from version control.

## Submission ready

This repository is prepared for submission with a complete backend API, authentication, database models, and frontend interface. The project is structured, documented, and ready for review.
