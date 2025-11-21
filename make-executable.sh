#!/bin/bash
# Make deployment scripts executable

chmod +x /workspaces/-Buildprogemini-/final-deploy.sh
chmod +x /workspaces/-Buildprogemini-/deploy.sh
chmod +x /workspaces/-Buildprogemini-/commit.sh
chmod +x /workspaces/-Buildprogemini-/vercel-deploy.sh
chmod +x /workspaces/-Buildprogemini-/backend/test-api.sh
chmod +x /workspaces/-Buildprogemini-/backend/check-status.sh
chmod +x /workspaces/-Buildprogemini-/backend/verify-setup.sh
chmod +x /workspaces/-Buildprogemini-/backend/setup-backend.sh
chmod +x /workspaces/-Buildprogemini-/backend/supabase-setup.sh

echo "✅ All deployment scripts are now executable"
echo ""
echo "You can run:"
echo "  ./final-deploy.sh     - Complete deployment automation"
echo "  ./deploy.sh           - Interactive deployment menu"
echo "  ./commit.sh           - Commit changes to Git"
echo "  ./vercel-deploy.sh    - Direct Vercel CLI deployment"
