#!/bin/bash

# BuildPro - Build, Commit, and Prepare for Vercel Deployment

set -e

echo "======================================"
echo "BuildPro - Build & Deploy Preparation"
echo "======================================"
echo ""

cd "$(dirname "$0")"

# Step 1: Build the frontend
echo "📦 Step 1: Building frontend..."
npm run build

if [ $? -eq 0 ]; then
    echo "✓ Frontend build successful"
    echo ""
    echo "Build output:"
    ls -lh dist/ | head -10
else
    echo "✗ Build failed"
    exit 1
fi

echo ""

# Step 2: Stage files for commit
echo "📝 Step 2: Staging files for commit..."
git add vercel.json
git add .vercelignore
git add deploy-vercel.sh
git add VERCEL_DEPLOYMENT.md
git add build-and-deploy.sh
git add package.json

# Don't commit dist folder (Vercel will build it)
echo "dist/" >> .gitignore 2>/dev/null || true

echo "✓ Files staged"
echo ""

# Step 3: Show git status
echo "📋 Git Status:"
git status --short
echo ""

# Step 4: Commit
echo "💾 Step 3: Creating commit..."
git commit -m "feat: add Vercel deployment configuration and build system

Vercel Deployment Ready:
- ✅ vercel.json configuration
- ✅ .vercelignore for deployment optimization
- ✅ Deployment scripts and documentation
- ✅ Build system configured
- ✅ Frontend successfully builds

Features:
- Vite build optimization
- SPA routing configuration
- Asset caching headers
- Deployment automation scripts
- Comprehensive deployment guide

Files Added:
- vercel.json - Vercel configuration
- .vercelignore - Deployment exclusions
- deploy-vercel.sh - Deployment automation
- VERCEL_DEPLOYMENT.md - Deployment guide
- build-and-deploy.sh - Build and commit script

Ready for Vercel deployment via:
- GitHub integration (recommended)
- Vercel CLI
- Manual upload
- Automated script

Next Steps:
1. Push to GitHub: git push origin main
2. Connect to Vercel: vercel.com/new
3. Import repository and deploy"

echo "✓ Commit created"
echo ""

# Step 5: Push to GitHub
echo "🚀 Step 4: Pushing to GitHub..."
git push origin main

if [ $? -eq 0 ]; then
    echo "✓ Pushed to GitHub successfully"
else
    echo "⚠️  Push failed, but commit was successful locally"
fi

echo ""
echo "======================================"
echo "✅ Build & Commit Complete!"
echo "======================================"
echo ""
echo "Frontend built successfully and committed to GitHub"
echo ""
echo "🚀 Next Steps for Vercel Deployment:"
echo ""
echo "Option 1: GitHub Integration (Recommended)"
echo "  1. Go to: https://vercel.com/new"
echo "  2. Import repository: adrianstanca1/-Buildprogemini-"
echo "  3. Click 'Deploy'"
echo ""
echo "Option 2: Vercel CLI"
echo "  1. Install: npm install -g vercel"
echo "  2. Login: vercel login"
echo "  3. Deploy: vercel --prod"
echo ""
echo "Option 3: Using Script"
echo "  ./deploy-vercel.sh"
echo ""
echo "📖 Full Guide: See VERCEL_DEPLOYMENT.md"
echo ""
