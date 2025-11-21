#!/bin/bash

# BuildPro Project Cleanup Script
# Removes duplicates, fixes conflicts, cleans dead code

set -e

cd /workspaces/-Buildprogemini-

echo "🧹 BuildPro Project Cleanup"
echo "==========================="
echo ""

# Remove duplicate deployment scripts
echo "📦 Removing duplicate deployment scripts..."
rm -f deploy.sh deploy-to-vercel.sh deploy-vercel.sh \
      deploy-fullstack.sh deploy-helper.sh \
      build-and-deploy.sh quick-deploy.sh \
      DEPLOY.sh finalize-deployment.sh

# Remove duplicate commit scripts
echo "📦 Removing duplicate commit scripts..."
rm -f commit-all.sh commit-backend.sh commit-fixes.sh \
      commit-and-deploy.sh do-commit.sh

# Remove duplicate deployment docs
echo "📄 Removing duplicate documentation..."
rm -f DEPLOY_NOW.md DEPLOYMENT_READY.md DEPLOYMENT_STATUS.md \
      FULLSTACK_DEPLOYMENT.md QUICK_DEPLOY.md \
      VERCEL_AUTO_DEPLOY.md VERCEL_DEPLOYMENT.md \
      VERCEL_SUPABASE_DEPLOYMENT.md

# Remove temporary/generated files
echo "🗑️  Removing temporary files..."
rm -f git-commit.py 2>/dev/null || true
rm -f .cleanup-report.md 2>/dev/null || true

# Remove unused integration scripts
echo "🔧 Removing unused scripts..."
rm -f integrate-supabase.sh test-supabase.sh \
      generate-jwt-secret.sh vercel-build.sh

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "Remaining files:"
echo "  Scripts:"
echo "    - DEPLOY_FIXED.sh (master deployment)"
echo "    - deploy-now.sh (quick deploy)"  
echo "    - commit-backend-fixes.sh (commit helper)"
echo ""
echo "  Documentation:"
echo "    - VERCEL_DEPLOYMENT_COMPLETE.md (deployment guide)"
echo "    - QUICK_DEPLOY_GUIDE.md (quick reference)"
echo "    - FIXES_APPLIED.md (changelog)"
echo "    - backend/DEPLOYMENT.md (backend guide)"
echo ""
