#!/bin/bash

# BuildPro - Complete Build and Vercel Deployment
# This script builds, commits, and provides deployment instructions

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
echo "╔════════════════════════════════════════╗"
echo "║   BuildPro - Vercel Deployment Tool   ║"
echo "╔════════════════════════════════════════╗"
echo -e "${NC}"
echo ""

# Navigate to project root
cd "$(dirname "$0")"

# Step 1: Check prerequisites
echo -e "${BLUE}📋 Step 1: Checking Prerequisites${NC}"
echo "-----------------------------------"

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    echo -e "${GREEN}✓${NC} Node.js ${NODE_VERSION}"
else
    echo -e "${RED}✗${NC} Node.js not found"
    exit 1
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    echo -e "${GREEN}✓${NC} npm ${NPM_VERSION}"
else
    echo -e "${RED}✗${NC} npm not found"
    exit 1
fi

# Check if dependencies are installed
if [ -d "node_modules" ]; then
    echo -e "${GREEN}✓${NC} Dependencies installed"
else
    echo -e "${YELLOW}⚠${NC} Dependencies not found. Installing..."
    npm install
fi

echo ""

# Step 2: Build the project
echo -e "${BLUE}📦 Step 2: Building Frontend${NC}"
echo "----------------------------"

npm run build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Build successful!"
    echo ""
    echo "Build output:"
    ls -lh dist/ 2>/dev/null | head -5
else
    echo -e "${RED}✗${NC} Build failed!"
    echo "Please fix build errors before deploying"
    exit 1
fi

echo ""

# Step 3: Check Git status
echo -e "${BLUE}📝 Step 3: Git Status${NC}"
echo "-------------------"

# Check if git repo exists
if [ -d ".git" ]; then
    echo -e "${GREEN}✓${NC} Git repository found"
    
    # Check for uncommitted changes
    if [ -n "$(git status --porcelain)" ]; then
        echo -e "${YELLOW}⚠${NC} Uncommitted changes found"
        echo ""
        git status --short
        echo ""
        read -p "Commit changes now? [Y/n] " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]] || [ -z "$REPLY" ]; then
            git add vercel.json .vercelignore deploy-vercel.sh VERCEL_DEPLOYMENT.md DEPLOYMENT_READY.md build-and-deploy.sh deploy.sh README.md
            git commit -m "feat: configure Vercel deployment with build system

- Add Vercel configuration (vercel.json)
- Add deployment scripts and automation
- Add comprehensive deployment documentation
- Update README with deployment section
- Configure build optimization
- Add deployment exclusions (.vercelignore)

Ready for Vercel deployment via GitHub integration or CLI"
            
            echo -e "${GREEN}✓${NC} Changes committed"
            
            read -p "Push to GitHub? [Y/n] " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]] || [ -z "$REPLY" ]; then
                git push origin main
                echo -e "${GREEN}✓${NC} Pushed to GitHub"
            fi
        fi
    else
        echo -e "${GREEN}✓${NC} No uncommitted changes"
    fi
else
    echo -e "${YELLOW}⚠${NC} Not a git repository"
fi

echo ""

# Step 4: Deployment options
echo -e "${BLUE}🚀 Step 4: Deployment Options${NC}"
echo "-----------------------------"
echo ""
echo "Choose your deployment method:"
echo ""
echo -e "${GREEN}1. GitHub + Vercel${NC} (Recommended - Easiest)"
echo "   • Auto-deploy on every push"
echo "   • Preview deployments for PRs"
echo "   • Easy rollbacks"
echo ""
echo -e "${GREEN}2. Vercel CLI${NC} (Fast)"
echo "   • Deploy immediately from terminal"
echo "   • Good for quick testing"
echo ""
echo -e "${GREEN}3. Manual Upload${NC}"
echo "   • Upload dist folder directly"
echo "   • No git integration needed"
echo ""

read -p "Select option (1-3) or 'q' to quit: " choice

case $choice in
    1)
        echo ""
        echo -e "${BLUE}GitHub + Vercel Deployment${NC}"
        echo "========================="
        echo ""
        echo "Steps:"
        echo "1. Go to: https://vercel.com/new"
        echo "2. Click 'Import Git Repository'"
        echo "3. Select repository: adrianstanca1/-Buildprogemini-"
        echo "4. Vercel will auto-detect Vite settings"
        echo "5. Click 'Deploy'"
        echo ""
        echo "Your app will be live in ~2 minutes!"
        echo ""
        echo "Opening Vercel..."
        sleep 2
        if command -v xdg-open &> /dev/null; then
            xdg-open "https://vercel.com/new" 2>/dev/null
        elif command -v open &> /dev/null; then
            open "https://vercel.com/new"
        else
            echo "Please open: https://vercel.com/new"
        fi
        ;;
    2)
        echo ""
        echo -e "${BLUE}Vercel CLI Deployment${NC}"
        echo "===================="
        echo ""
        
        if command -v vercel &> /dev/null; then
            echo -e "${GREEN}✓${NC} Vercel CLI found"
            echo ""
            read -p "Deploy to production? [Y/n] " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]] || [ -z "$REPLY" ]; then
                vercel --prod
            else
                vercel
            fi
        else
            echo "Vercel CLI not found. Installing..."
            npm install -g vercel
            echo ""
            echo "Now run: vercel --prod"
        fi
        ;;
    3)
        echo ""
        echo -e "${BLUE}Manual Upload${NC}"
        echo "============="
        echo ""
        echo "Steps:"
        echo "1. Go to: https://vercel.com/new"
        echo "2. Click 'Continue with Other'"
        echo "3. Drag and drop the 'dist' folder"
        echo "4. Click 'Deploy'"
        echo ""
        echo "Dist folder location: $(pwd)/dist"
        ;;
    q|Q)
        echo ""
        echo "Deployment cancelled"
        exit 0
        ;;
    *)
        echo ""
        echo "Invalid option"
        exit 1
        ;;
esac

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║         Deployment Ready! 🚀           ║${NC}"
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo ""
echo "📖 Full deployment guide: VERCEL_DEPLOYMENT.md"
echo "📊 Deployment status: DEPLOYMENT_READY.md"
echo ""
echo "After deployment:"
echo "• Your app will be live at: https://your-project.vercel.app"
echo "• Automatic HTTPS enabled"
echo "• CDN distribution active"
echo "• Analytics available in Vercel dashboard"
echo ""
echo -e "${YELLOW}Note:${NC} Backend needs separate deployment (see backend/DEPLOYMENT.md)"
echo ""
