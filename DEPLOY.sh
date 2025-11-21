DATABASE_URL=postgresql://postgres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres
NODE_ENV=production
JWT_SECRET=buildpro_jwt_secret_2025_production_key_secure_random_string
CORS_ORIGIN=https://your-app.vercel.appchmod +x DEPLOY.sh
./DEPLOY.shchmod +x quick-deploy.sh
./quick-deploy.shDATABASE_URL=postgresql://postgres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres
NODE_ENV=production
JWT_SECRET=buildpro_jwt_secret_2025_production_key_secure_random_string
CORS_ORIGIN=https://your-app.vercel.app#!/bin/bash

# BuildPro - Complete Deployment Script
# Automated deployment to Vercel with all checks
echo "========================================"
echo "🚀 BuildPro Deployment Script"
echo "========================================"
echo ""======================================="
echo "🚀 BuildPro Deployment Script"
# Color codes================================="
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'm'
NC='\033[0m' # No Color
YELLOW='\033[1;33m'
# Navigate to project root
cd /workspaces/-Buildprogemini-

# Check if Vercel CLI is installed
echo -e "${BLUE}Checking Vercel CLI...${NC}"
if ! command -v vercel &> /dev/null; then
    echo -e "${YELLOW}Vercel CLI not found. Installing...${NC}"
    npm install -g vercelVercel CLI...${NC}"
    echo -e "${GREEN}✓ Vercel CLI installed${NC}"
elseecho -e "${YELLOW}Vercel CLI not found. Installing...${NC}"
    echo -e "${GREEN}✓ Vercel CLI found${NC}"
fi  echo -e "${GREEN}✓ Vercel CLI installed${NC}"
echo ""
    echo -e "${GREEN}✓ Vercel CLI found${NC}"
# Build Frontend
echo -e "${BLUE}Building Frontend...${NC}"
echo "================================"
npm installntend
npm run buildUE}Building Frontend...${NC}"
echo "================================"
if [ -d "dist" ]; then
    echo -e "${GREEN}✓ Frontend built successfully${NC}"
    echo "  Build size: $(du -sh dist 2>/dev/null | cut -f1 || echo 'N/A')"
else -d "dist" ]; then
    echo -e "${RED}✗ Frontend build failed!${NC}"y${NC}"
    exit 1  Build size: $(du -sh dist 2>/dev/null | cut -f1 || echo 'N/A')"
fise
echo ""o -e "${RED}✗ Frontend build failed!${NC}"
    exit 1
# Build Backend
echo -e "${BLUE}Building Backend...${NC}"
echo "================================"
cd backendckend
npm installBLUE}Building Backend...${NC}"
npm run build========================="
cd backend
if [ -d "dist" ]; then
    echo -e "${GREEN}✓ Backend built successfully${NC}"
    echo "  Build size: $(du -sh dist 2>/dev/null | cut -f1 || echo 'N/A')"
else -d "dist" ]; then
    echo -e "${RED}✗ Backend build failed!${NC}"y${NC}"
    exit 1  Build size: $(du -sh dist 2>/dev/null | cut -f1 || echo 'N/A')"
fise
cd ..cho -e "${RED}✗ Backend build failed!${NC}"
echo ""t 1
fi
# Verify environment file
echo -e "${BLUE}Checking Environment Configuration...${NC}"
echo "================================"
if [ -f ".env.vercel" ]; then
    echo -e "${GREEN}✓ .env.vercel found${NC}"tion...${NC}"
    echo ""==========================="
    echo "Environment variables to configure on Vercel:"
    echo "  • DATABASE_URL (Supabase PostgreSQL)"
    echo "  • NODE_ENV=production"
    echo "  • JWT_SECRET"iables to configure on Vercel:"
    echo "  • CORS_ORIGIN (update after first deploy)"
    echo "" • NODE_ENV=production"
elseecho "  • JWT_SECRET"
    echo -e "${YELLOW}⚠ .env.vercel not found${NC}"y)"
fi  echo ""
echo ""
    echo -e "${YELLOW}⚠ .env.vercel not found${NC}"
# Deploy to Vercel
echo -e "${BLUE}Deploying to Vercel...${NC}"
echo "================================"
echo ""y to Vercel
echo "Choose deployment method:"cel...${NC}"
echo "  1) Production deployment (recommended)"
echo "  2) Preview deployment"
echo "  3) Skip deployment (manual later)"
echo "" 1) Production deployment (recommended)"
read -p "Enter choice (1-3): " choice
echo "  3) Skip deployment (manual later)"
case $choice in
    1)p "Enter choice (1-3): " choice
        echo ""
        echo -e "${BLUE}🚀 Deploying to Production...${NC}"
        vercel --prod
        ;;ho ""
    2)  echo -e "${BLUE}🚀 Deploying to Production...${NC}"
        echo ""--prod
        echo -e "${BLUE}🚀 Creating Preview Deployment...${NC}"
        vercel
        ;;ho ""
    3)  echo -e "${BLUE}🚀 Creating Preview Deployment...${NC}"
        echo ""
        echo -e "${YELLOW}Skipping deployment${NC}"
        echo ""
        echo "To deploy manually later:"
        echo "  vercel --prod"ping deployment${NC}"
        ;;ho ""
    *)  echo "To deploy manually later:"
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac    echo -e "${RED}Invalid choice${NC}"
        exit 1
echo "" ;;
echo "========================================"
echo -e "${GREEN}✅ Deployment Process Complete!${NC}"
echo "========================================"
echo ""======================================="
echo "Next Steps:" Deployment Process Complete!${NC}"
echo ""======================================="
echo "1. Configure Environment Variables on Vercel:"
echo "   Go to: https://vercel.com/your-project/settings/environment-variables"
echo ""
echo "   Add these variables:" Variables on Vercel:"
echo "   • DATABASE_URL = postgresql://postgres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres"
echo "   • NODE_ENV = production"
echo "   • JWT_SECRET = buildpro_jwt_secret_2025_production_key_secure_random_string"
echo "   • CORS_ORIGIN = [Your Vercel URL]"gres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres"
echo ""  • NODE_ENV = production"
echo "2. After adding environment variables:"025_production_key_secure_random_string"
echo "   Redeploy from Vercel dashboard or run: vercel --prod"
echo ""
echo "3. Test your deployment:"nt variables:"
echo "   • Frontend: https://your-app.vercel.app"ercel --prod"
echo "   • API Health: https://your-app.vercel.app/api/v1/health"
echo "". Test your deployment:"
echo "4. Run database migrations (if needed):"pp"
echo "   Use Vercel CLI or connect to your deployment"/v1/health"
echo ""
echo "📚 Documentation:"grations (if needed):"
echo "   • See .env.vercel for complete setup instructions"
echo "   • See FIXES_APPLIED.md for recent changes"
echo "   • See backend/DEPLOYMENT.md for detailed deployment guide"
echo "   • See .env.vercel for complete setup instructions"
echo "   • See FIXES_APPLIED.md for recent changes"
echo "   • See backend/DEPLOYMENT.md for detailed deployment guide"
