#!/bin/bash
# Force clean build - bypasses all caches

set -e

echo "════════════════════════════════════════"
echo "  FORCE CLEAN BUILD"
echo "════════════════════════════════════════"
echo ""

cd /workspaces/-Buildprogemini-

# Step 1: Clean everything
echo "1️⃣  Cleaning all build artifacts..."
rm -rf dist
rm -rf backend/dist
rm -rf backend/node_modules/.vite
rm -rf backend/node_modules/.cache
rm -rf node_modules/.vite  
rm -rf node_modules/.cache
rm -rf .tsbuildinfo
rm -rf backend/.tsbuildinfo
echo "   ✓ Cleaned"

# Step 2: Verify source file
echo ""
echo "2️⃣  Verifying source file fixes..."
if grep -q "as string" backend/src/controllers/authController.ts; then
    echo "   ✓ authController.ts has type assertions"
else
    echo "   ✗ authController.ts missing type assertions!"
    echo ""
    echo "   Applying fix now..."
    
    # Create backup
    cp backend/src/controllers/authController.ts backend/src/controllers/authController.ts.backup
    
    # Apply fix with sed
    sed -i "s/{ expiresIn: process.env.JWT_EXPIRES_IN || '7d' }/{ expiresIn: (process.env.JWT_EXPIRES_IN || '7d') as string }/g" backend/src/controllers/authController.ts
    
    echo "   ✓ Fix applied"
fi

# Step 3: Build backend fresh
echo ""
echo "3️⃣  Building backend (fresh)..."
cd backend
npm run build 2>&1 | tee build.log

if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "   ✓ Backend build successful!"
    
    # Verify output
    if [ -f "dist/server.js" ]; then
        FILE_COUNT=$(find dist -type f -name "*.js" | wc -l)
        echo "   ✓ Generated $FILE_COUNT JavaScript files"
    fi
else
    echo "   ✗ Backend build failed!"
    echo ""
    echo "Build log:"
    tail -20 build.log
    exit 1
fi

cd ..

# Step 4: Build frontend
echo ""
echo "4️⃣  Building frontend..."
npm run build

if [ $? -eq 0 ]; then
    echo "   ✓ Frontend build successful!"
else
    echo "   ✗ Frontend build failed!"
    exit 1
fi

# Step 5: Summary
echo ""
echo "════════════════════════════════════════"
echo "  ✅ ALL BUILDS SUCCESSFUL"
echo "════════════════════════════════════════"
echo ""
echo "Build outputs:"
echo "  📁 dist/             - Frontend"
echo "  📁 backend/dist/     - Backend API"
echo ""
echo "Next step: Deploy to Vercel"
echo "  Option 1: https://vercel.com/new"
echo "  Option 2: vercel --prod"
echo ""
