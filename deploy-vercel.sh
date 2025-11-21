#!/bin/bash

# BuildPro - Vercel Deployment Script

set -e

echo "======================================"
echo "BuildPro - Vercel Deployment"
echo "======================================"
echo ""

# Navigate to project root
cd "$(dirname "$0")"

# Check if Vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "⚠️  Vercel CLI not found. Installing..."
    npm install -g vercel
fi

echo "✓ Vercel CLI ready"
echo ""

# Build the project
echo "📦 Building frontend..."
npm run build

if [ $? -eq 0 ]; then
    echo "✓ Frontend build successful"
else
    echo "✗ Build failed"
    exit 1
fi

echo ""
echo "📊 Build output:"
ls -lh dist/

echo ""
echo "======================================"
echo "Deployment Options"
echo "======================================"
echo ""
echo "Choose deployment method:"
echo ""
echo "1. Deploy to Vercel (Production)"
echo "   Command: vercel --prod"
echo ""
echo "2. Deploy to Vercel (Preview)"
echo "   Command: vercel"
echo ""
echo "3. Manual deployment"
echo "   - Upload the 'dist' folder to Vercel dashboard"
echo "   - Or connect your GitHub repository"
echo ""
echo "To deploy now, run:"
echo "  vercel --prod    # Production deployment"
echo "  vercel           # Preview deployment"
echo ""
