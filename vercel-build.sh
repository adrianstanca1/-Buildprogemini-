#!/bin/bash
set -e

echo "🏗️  Building BuildPro for Vercel..."

# Build frontend
echo "📦 Building frontend..."
npm install
npm run build

# Build backend
echo "🔧 Building backend..."
cd backend
npm install
npm run build

echo "✅ Build complete!"
