#!/bin/bash

# BuildPro - Complete Deployment Script  
# Automated deployment to Vercel with all checks

set -e

echo "========================================"
echo "🚀 BuildPro Deployment Script"
echo "========================================"
echo ""

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Navigate to project root
cd /workspaces/-Buildprogemini-

# Check if Vercel CLI is installed
echo -e "${BLUE}Checking Vercel CLI...${NC}"
if ! command -v vercel &> /dev/null; then
    echo -e "${YELLOW}Vercel CLI not found. Installing...${NC}"
    npm install -g vercel
    echo -e "${GREEN}✓ Vercel CLI installed${NC}"
else
    echo -e "${GREEN}✓ Vercel CLI found${NC}"
fi
echo ""

# Build Frontend
echo -e "${BLUE}Building Frontend...${NC}"
echo "================================"
npm install
npm run build

if [ -d "dist" ]; then
    echo -e "${GREEN}✓ Frontend built successfully${NC}"
    echo "  Build size: $(du -sh dist 2>/dev/null | cut -f1 || echo 'N/A')"
else
    echo -e "${RED}✗ Frontend build failed!${NC}"
    exit 1
fi
echo ""

# Build Backend
echo -e "${BLUE}Building Backend...${NC}"
echo "================================"
cd backend
npm install
npm run build

if [ -d "dist" ]; then
    echo -e "${GREEN}✓ Backend built successfully${NC}"
    echo "  Build size: $(du -sh dist 2>/dev/null | cut -f1 || echo 'N/A')"
else
    echo -e "${RED}✗ Backend build failed!${NC}"
    exit 1
fi
cd ..
echo ""

# Verify environment file
echo -e "${BLUE}Checking Environment Configuration...${NC}"
echo "================================"
if [ -f ".env.vercel" ]; then
    echo -e "${GREEN}✓ .env.vercel found${NC}"
    echo ""
    echo "Environment variables to configure on Vercel:"
    echo "  • DATABASE_URL (Supabase PostgreSQL)"
    echo "  • NODE_ENV=production"
    echo "  • JWT_SECRET"
    echo "  • CORS_ORIGIN (update after first deploy)"
    echo ""
else
    echo -e "${YELLOW}⚠ .env.vercel not found${NC}"
fi
echo ""

# Deploy to Vercel
echo -e "${BLUE}Deploying to Vercel...${NC}"
echo "================================"
echo ""
echo "Choose deployment method:"
echo "  1) Production deployment (recommended)"
echo "  2) Preview deployment"
echo "  3) Skip deployment (manual later)"
echo ""
read -p "Enter choice (1-3): " choice

case $choice in
    1)
        echo ""
        echo -e "${BLUE}🚀 Deploying to Production...${NC}"
        vercel --prod
        ;;
    2)
        echo ""
        echo -e "${BLUE}🚀 Creating Preview Deployment...${NC}"
        vercel
        ;;
    3)
        echo ""
        echo -e "${YELLOW}Skipping deployment${NC}"
        echo ""
        echo "To deploy manually later:"
        echo "  vercel --prod"
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac

echo ""
echo "========================================"
echo -e "${GREEN}✅ Deployment Process Complete!${NC}"
echo "========================================"
echo ""
echo "Next Steps:"
echo ""
echo "1. Configure Environment Variables on Vercel:"
echo "   Go to: https://vercel.com/your-project/settings/environment-variables"
echo ""
echo "   Add these variables:"
echo "   • DATABASE_URL = postgresql://postgres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres"
echo "   • NODE_ENV = production"
echo "   • JWT_SECRET = buildpro_jwt_secret_2025_production_key_secure_random_string"
echo "   • CORS_ORIGIN = [Your Vercel URL]"
echo ""
echo "2. After adding environment variables:"
echo "   Redeploy from Vercel dashboard or run: vercel --prod"
echo ""
echo "3. Test your deployment:"
echo "   • Frontend: https://your-app.vercel.app"
echo "   • API Health: https://your-app.vercel.app/api/v1/health"
echo ""
echo "4. Run database migrations (if needed):"
echo "   Use Vercel CLI or connect to your deployment"
echo ""
echo "📚 Documentation:"
echo "   • See .env.vercel for complete setup instructions"
echo "   • See FIXES_APPLIED.md for recent changes"
echo "   • See backend/DEPLOYMENT.md for detailed deployment guide"
echo ""
