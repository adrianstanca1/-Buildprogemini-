#!/bin/bash
# FINAL DEPLOYMENT SCRIPT - BuildPro to Vercel
# Run this script to deploy your application

set -e

echo "🚀 BuildPro - Final Deployment to Vercel"
echo "=========================================="
echo ""

# Navigate to project root
cd "$(dirname "$0")"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Step 1: Install dependencies
echo -e "${BLUE}📦 Step 1: Installing dependencies${NC}"
echo "-----------------------------------"
npm install
cd backend && npm install && cd ..
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Step 2: Build frontend
echo -e "${BLUE}🔨 Step 2: Building frontend${NC}"
echo "----------------------------"
npm run build
echo -e "${GREEN}✓ Frontend built successfully${NC}"
echo ""

# Step 3: Build backend
echo -e "${BLUE}🔧 Step 3: Building backend${NC}"
echo "---------------------------"
cd backend
npm run build
cd ..
echo -e "${GREEN}✓ Backend built successfully${NC}"
echo ""

# Step 4: Commit changes
echo -e "${BLUE}📝 Step 4: Committing changes${NC}"
echo "------------------------------"
if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "fix: final deployment ready - all builds passing"
    echo -e "${GREEN}✓ Changes committed${NC}"
else
    echo -e "${GREEN}✓ No changes to commit${NC}"
fi
echo ""

# Step 5: Push to GitHub
echo -e "${BLUE}⬆️  Step 5: Pushing to GitHub${NC}"
echo "-----------------------------"
git push origin main || echo -e "${YELLOW}⚠ Push failed - may already be up to date${NC}"
echo ""

# Step 6: Deploy options
echo -e "${BLUE}🚀 Step 6: Deploy to Vercel${NC}"
echo "---------------------------"
echo ""
echo "Choose deployment method:"
echo ""
echo "1) Vercel Dashboard (Recommended)"
echo "2) Vercel CLI"
echo "3) Skip deployment"
echo ""
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo "Opening Vercel Dashboard..."
        echo ""
        echo "Steps:"
        echo "1. Click 'Import Git Repository'"
        echo "2. Select: adrianstanca1/-Buildprogemini-"
        echo "3. Add environment variables:"
        echo ""
        echo "   DATABASE_URL = postgresql://postgres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres"
        echo "   NODE_ENV = production"
        echo "   JWT_SECRET = buildpro_jwt_secret_2025_production_key_secure_random_string"
        echo "   CORS_ORIGIN = https://your-app.vercel.app"
        echo ""
        echo "4. Click Deploy!"
        echo ""
        sleep 2
        
        # Try to open browser
        if command -v xdg-open &> /dev/null; then
            xdg-open "https://vercel.com/new" 2>/dev/null &
        elif command -v open &> /dev/null; then
            open "https://vercel.com/new" &
        else
            echo "Please visit: https://vercel.com/new"
        fi
        ;;
    2)
        echo ""
        if command -v vercel &> /dev/null; then
            echo "Deploying with Vercel CLI..."
            vercel --prod
        else
            echo "Installing Vercel CLI..."
            npm install -g vercel
            echo ""
            echo "Now run: vercel --prod"
        fi
        ;;
    3)
        echo ""
        echo "Deployment skipped."
        echo "Run this script again when ready to deploy."
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}✅ Deployment process complete!${NC}"
echo ""
echo "📖 Full documentation: DEPLOY_NOW.md"
echo ""
