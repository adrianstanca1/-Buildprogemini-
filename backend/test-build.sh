#!/bin/bash
# Backend Build & Deploy Test

set -e

echo "🔧 Testing Backend Build..."
echo "=============================="
echo ""

cd "$(dirname "$0")"

# Install dependencies
echo "📦 Installing dependencies..."
npm install --silent

# Run TypeScript build
echo "🔨 Building TypeScript..."
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Backend build successful!"
    echo ""
    echo "📊 Build output:"
    ls -lh dist/ | head -10
    echo ""
    
    # Check for critical files
    if [ -f "dist/server.js" ]; then
        echo "✅ dist/server.js found"
    else
        echo "❌ dist/server.js missing!"
        exit 1
    fi
    
    # Count built files
    FILE_COUNT=$(find dist -type f | wc -l)
    echo "✅ Built $FILE_COUNT files"
    echo ""
    echo "🚀 Backend is ready for deployment!"
else
    echo ""
    echo "❌ Backend build failed!"
    echo ""
    echo "Common fixes:"
    echo "1. Check TypeScript errors: npm run build"
    echo "2. Verify all imports use .js extensions"
    echo "3. Check tsconfig.json configuration"
    exit 1
fi
