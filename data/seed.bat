@echo off
echo 🚀 SocialShare Firestore Seeder
echo ================================
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js is not installed. Please install Node.js first.
    echo Download from: https://nodejs.org/
    pause
    exit /b 1
)

REM Check if service account key exists
if not exist "serviceAccountKey.json" (
    echo ❌ serviceAccountKey.json not found!
    echo.
    echo Please follow these steps:
    echo 1. Go to Firebase Console ^> Project Settings ^> Service Accounts
    echo 2. Click "Generate new private key"
    echo 3. Download and rename to serviceAccountKey.json
    echo 4. Place it in this directory
    echo.
    pause
    exit /b 1
)

REM Install dependencies if node_modules doesn't exist
if not exist "node_modules" (
    echo 📦 Installing dependencies...
    npm install
    if %errorlevel% neq 0 (
        echo ❌ Failed to install dependencies
        pause
        exit /b 1
    )
)

echo ✅ Dependencies installed
echo 🚀 Starting seeding process...
echo.

REM Run the seeder
npm run seed

echo.
echo ✅ Seeding completed!
pause
