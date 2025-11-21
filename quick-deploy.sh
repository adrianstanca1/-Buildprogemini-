#!/bin/bash

# Quick Deploy to Vercel - BuildPro
# Simplified deployment with automatic checks

cd /workspaces/-Buildprogemini-

echo "🚀 BuildPro - Quick Deploy to Vercel"
echo "====================================="
echo ""

# Install Vercel CLI if not present
if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI..."
    npm i -g vercel
fi

# Build the project
echo "🔨 Building project..."
npm run build

# Deploy to Vercel
echo ""
echo "🚀 Deploying to Vercel..."
echo ""
echo "If prompted:"
echo "  - Select your account"
echo "  - Confirm project settings"
echo "  - Deploy to production"
echo ""

vercel --prod

echo ""
echo "✅ Deployment initiated!"
echo ""
echo "Next steps:"
echo "1. Add environment variables in Vercel Dashboard"
echo "2. See QUICK_DEPLOY_GUIDE.md for complete instructions"
