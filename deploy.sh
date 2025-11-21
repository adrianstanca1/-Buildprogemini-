#!/bin/bash
set -e

echo "🚀 COMPLETE VERCEL DEPLOYMENT FIX"
echo "=================================="
echo ""

# Step 1: Remove API handler
echo "Step 1: Removing API handler files..."
rm -rf api/
rm -f tsconfig.api.json
echo "✅ Removed API handler"

# Step 2: Clean and build
echo ""
echo "Step 2: Clean build..."
rm -rf dist
rm -rf node_modules/.vite
npm install --silent
npm run build

if [ ! -f "dist/index.html" ]; then
    echo "❌ Build failed"
    exit 1
fi
echo "✅ Build successful"

# Step 3: Commit
echo ""
echo "Step 3: Committing..."
git add -A
git commit -m "fix: minimal vercel config - frontend only SPA

- Removed api/ directory causing build conflicts
- Removed tsconfig.api.json
- Ultra-minimal vercel.json with only SPA rewrite
- Tested build locally - working"

# Step 4: Push
echo ""
echo "Step 4: Pushing..."
git push origin main

echo ""
echo "✅ DEPLOYED! Vercel will auto-deploy in 2-3 minutes."
echo "   Check: https://vercel.com/dashboard"
