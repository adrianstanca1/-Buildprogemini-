#!/bin/bash

# BuildPro - Execute Vercel Deployment
# Run this to deploy to Vercel now

set -e

cd /workspaces/-Buildprogemini-

echo "═══════════════════════════════════════"
echo "🚀 BuildPro - Vercel Deployment"
echo "═══════════════════════════════════════"
echo ""

# Commit any remaining changes
echo "📦 Preparing files..."
git add .github/workflows/deploy.yml \
        VERCEL_DEPLOYMENT_COMPLETE.md \
        DEPLOY.sh \
        quick-deploy.sh \
        QUICK_DEPLOY_GUIDE.md \
        finalize-deployment.sh \
        deploy-now.sh 2>/dev/null || true

if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    git commit -m "feat: Add complete Vercel deployment setup" || true
    git push origin main || echo "⚠️  Manual push may be needed"
fi

echo "✅ Files ready"
echo ""

# Check for Vercel CLI
echo "🔍 Checking Vercel CLI..."
if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI..."
    npm install -g vercel
fi

echo "✅ Vercel CLI ready"
echo ""

# Build project
echo "🔨 Building project..."
echo ""

echo "Building frontend..."
npm install --silent
npm run build

echo ""
echo "Building backend..."
cd backend
npm install --silent
npm run build
cd ..

echo ""
echo "✅ Builds complete"
echo ""

# Deploy to Vercel
echo "═══════════════════════════════════════"
echo "🚀 Deploying to Vercel Production"
echo "═══════════════════════════════════════"
echo ""
echo "You'll be prompted to:"
echo "  1. Login to Vercel (if not already)"
echo "  2. Confirm project settings"
echo "  3. Set environment variables"
echo ""
echo "Starting deployment..."
echo ""

vercel --prod

echo ""
echo "═══════════════════════════════════════"
echo "✅ Deployment Complete!"
echo "═══════════════════════════════════════"
echo ""
echo "📝 Next steps:"
echo ""
echo "1. Add environment variables in Vercel Dashboard:"
echo "   DATABASE_URL, NODE_ENV, JWT_SECRET, CORS_ORIGIN"
echo ""
echo "2. Update CORS_ORIGIN with your Vercel URL"
echo ""
echo "3. Redeploy: vercel --prod"
echo ""
echo "4. Test: https://your-app.vercel.app/api/v1/health"
echo ""
echo "📚 See VERCEL_DEPLOYMENT_COMPLETE.md for details"
echo ""
