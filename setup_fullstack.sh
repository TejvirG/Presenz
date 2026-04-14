#!/usr/bin/env bash
# Setup script for Unix-like environments
cd "$(dirname "$0")/backend" || exit 1
echo "Installing backend dependencies..."
npm install

echo "Backend packages installed. Edit .env and run: node server.js or npx nodemon server.js"
echo "For frontend (Flutter): open the frontend folder and run: flutter pub get"
