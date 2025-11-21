#!/bin/bash
set -e

echo "🧹 Step 1: Clean old builds..."
rm -rf dist
rm -rf node_modules/.vite

echo "📦 Step 2: Install dependencies..."
npm install

echo "🔨 Step 3: Build frontend..."
npm run build

if [ ! -f "dist/index.html" ]; then
    echo "❌ Build failed - no dist/index.html"
    exit 1
fi

echo "✅ Build successful!"
ls -lh dist/
