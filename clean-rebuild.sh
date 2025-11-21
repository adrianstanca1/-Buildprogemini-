#!/bin/bash
# Clean rebuild script - fixes caching issues

echo "🧹 Cleaning build artifacts..."

# Clean backend
cd /workspaces/-Buildprogemini-/backend
rm -rf dist node_modules/.cache
echo "✓ Backend cleaned"

# Clean frontend
cd /workspaces/-Buildprogemini-
rm -rf dist node_modules/.cache
echo "✓ Frontend cleaned"

echo ""
echo "🔨 Rebuilding backend..."
cd /workspaces/-Buildprogemini-/backend
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Backend build successful!"
    cd ..
    
    echo ""
    echo "🔨 Rebuilding frontend..."
    npm run build
    
    if [ $? -eq 0 ]; then
        echo "✅ Frontend build successful!"
        echo ""
        echo "✅ ALL BUILDS PASSING!"
        echo ""
        echo "Ready to deploy to Vercel!"
    else
        echo "❌ Frontend build failed"
        exit 1
    fi
else
    echo "❌ Backend build failed"
    echo ""
    echo "Showing authController.ts lines 35-40:"
    sed -n '35,40p' src/controllers/authController.ts
    exit 1
fi
