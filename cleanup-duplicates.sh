#!/bin/bash
set -e

echo "🧹 Cleaning up duplicate and unused files..."

# Remove duplicate deployment scripts - keep MASTER_DEPLOY.sh and final-deploy.sh
rm -f quick-fix-deploy.sh
rm -f vercel-deploy.sh
rm -f deploy.sh
rm -f deploy-now.sh
rm -f continue-deploy.sh
rm -f commit-and-deploy.sh
rm -f clean-rebuild.sh
rm -f commit.sh
rm -f force-build.sh
rm -f make-executable.sh

echo "✅ Removed 10 duplicate deployment scripts"

# Remove duplicate documentation - keep main DEPLOYMENT.md and PROJECT_OVERVIEW.md
rm -f READY_TO_DEPLOY.md
rm -f DEPLOYMENT_STATUS.md
rm -f START_DEPLOYMENT.md
rm -f DEPLOY_NOW.md
rm -f backend/DEPLOYMENT.md

echo "✅ Removed 5 duplicate documentation files"

# Remove temporary/unused files
rm -f cleanup.py
rm -f validate-deployment.py
rm -f vercel-deploy.json
rm -f CLEANUP_GUIDE.md
rm -f DATABASE_URL.md
rm -f audit-fix.sh

echo "✅ Removed 6 temporary/unused files"

echo ""
echo "✅ Cleanup complete! Removed 21 files total."
echo "   Kept: MASTER_DEPLOY.sh, final-deploy.sh, DEPLOYMENT.md"
