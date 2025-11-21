#!/bin/bash
set -e

echo "🚀 Final Cleanup and Deployment"
echo "================================"
echo ""

# Step 1: Run cleanup
echo "📦 Step 1: Cleaning up duplicates..."
chmod +x cleanup-duplicates.sh
./cleanup-duplicates.sh

# Step 2: Rebuild to ensure everything works
echo ""
echo "🔨 Step 2: Rebuilding project..."
npm run build
cd backend && npm run build && cd ..

# Step 3: Commit all changes
echo ""
echo "📝 Step 3: Committing changes..."
git add -A
git commit -m "chore: cleanup duplicates and fix vulnerabilities

- Removed 10 duplicate deployment scripts
- Removed 5 duplicate documentation files  
- Removed 6 temporary/unused files
- Fixed npm security vulnerabilities
- Kept: MASTER_DEPLOY.sh, final-deploy.sh, DEPLOYMENT.md
- Ready for production deployment" || echo "No changes to commit"

# Step 4: Push to GitHub
echo ""
echo "⬆️  Step 4: Pushing to GitHub..."
git push origin main

echo ""
echo "✅ All done! Repository cleaned and pushed."
echo "   Vercel will auto-deploy the clean codebase."
