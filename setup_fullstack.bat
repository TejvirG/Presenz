@echo off
REM Setup script for Windows (install backend deps and show frontend hints)
cd /d "%~dp0\backend"
echo Installing backend dependencies...
npm install
echo Backend packages installed. Edit .env and run `node server.js` or `npx nodemon server.js`.
echo For frontend (Flutter): open the `frontend` folder and run `flutter pub get`.
pause
