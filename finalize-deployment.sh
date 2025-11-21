#!/bin/bash

# Final Deployment Preparation
# Commits deployment configurations and initiates Vercel deployment

cd /workspaces/-Buildprogemini-

echo "🚀 Final Deployment Preparation"
echo "================================"
echo ""

# Stage new deployment files
echo "📦 Staging deployment files..."
git add -A

# Check if there are changes
if git diff-index --quiet HEAD --; then
    echo "✅ No new changes to commit"
else
    # Commit deployment files
    echo "💾 Committing deployment configurations..."
    git commit -m "feat: Add comprehensive Vercel deployment configuration

Deployment Files Added:
- DEPLOY.sh - Interactive deployment script
- quick-deploy.sh - One-command deploy
- VERCEL_DEPLOYMENT_COMPLETE.md - Complete deployment guide
- QUICK_DEPLOY_GUIDE.md - Quick reference
- .github/workflows/deploy.yml - GitHub Actions auto-deploy

Features:
✅ Automated Vercel CLI deployment
✅ Interactive deployment wizard
✅ GitHub Actions integration
✅ Comprehensive documentation
✅ Environment variable templates
✅ Post-deployment verification

Ready for:
- One-click Vercel deployment
- GitHub auto-deployments
- Manual CLI deployment
- Complete production setup"

    echo "✅ Deployment files committed"
    
    # Push to GitHub
    echo ""
    echo "🚀 Pushing to GitHub..."
    if git push origin main; then
        echo "✅ Pushed to GitHub successfully"
    else
        echo "⚠️  Push failed - manual push may be needed"
    fi
fi

echo ""
echo "========================================"
echo "✅ Deployment Preparation Complete!"
echo "========================================"
echo ""
echo "🎯 Next Step: Deploy to Vercel"
echo ""
echo "Choose one method:"
echo ""
echo "1. 🌐 GitHub Import (Easiest):"
echo "   → Go to: https://vercel.com/new"
echo "   → Import: adrianstanca1/-Buildprogemini-"
echo "   → Add environment variables"
echo "   → Deploy!"
echo ""
echo "2. 💻 CLI Deploy:"
echo "   → npm i -g vercel"
echo "   → vercel login"
echo "   → vercel --prod"
echo ""
echo "3. 🤖 GitHub Actions:"
echo "   → Add VERCEL_TOKEN secret to GitHub"
echo "   → Push triggers auto-deploy"
echo ""
echo "📚 Full guide: VERCEL_DEPLOYMENT_COMPLETE.md"
echo ""
