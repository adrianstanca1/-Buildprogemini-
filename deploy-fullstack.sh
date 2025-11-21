#!/bin/bash

# BuildPro - Complete Full-Stack Deployment
# Deploys frontend to Vercel and backend to Railway with PostgreSQL

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════╗"
echo "║  BuildPro - Full-Stack Deployment Assistant  ║"
echo "╔═══════════════════════════════════════════════╗"
echo -e "${NC}"
echo ""

# Step 1: Build Frontend
echo -e "${BLUE}📦 Step 1: Building Frontend${NC}"
echo "=============================="
echo ""

npm run build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Frontend build successful${NC}"
else
    echo -e "${RED}✗ Frontend build failed${NC}"
    exit 1
fi

echo ""

# Step 2: Build Backend
echo -e "${BLUE}📦 Step 2: Building Backend${NC}"
echo "============================="
echo ""

cd backend
npm run build

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Backend build successful${NC}"
else
    echo -e "${RED}✗ Backend build failed${NC}"
    exit 1
fi

cd ..

echo ""

# Step 3: Deployment Options
echo -e "${BLUE}🚀 Step 3: Deployment Configuration${NC}"
echo "===================================="
echo ""
echo "Your BuildPro app is ready for deployment!"
echo ""
echo "Architecture:"
echo "  Frontend: Vercel (Static hosting)"
echo "  Backend: Railway.app (Node.js + PostgreSQL)"
echo "  Database: Railway PostgreSQL (managed)"
echo ""

# Step 4: Create Railway configuration
echo -e "${BLUE}📝 Step 4: Creating Deployment Configs${NC}"
echo "======================================="
echo ""

# Create railway.json if it doesn't exist
if [ ! -f "railway.json" ]; then
    cat > railway.json << 'EOF'
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "NIXPACKS",
    "buildCommand": "cd backend && npm install && npm run build"
  },
  "deploy": {
    "startCommand": "cd backend && npm start",
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
EOF
    echo -e "${GREEN}✓ Created railway.json${NC}"
fi

# Create Procfile for alternative deployments
if [ ! -f "backend/Procfile" ]; then
    echo "web: npm start" > backend/Procfile
    echo -e "${GREEN}✓ Created Procfile${NC}"
fi

# Create .env.production template
if [ ! -f "backend/.env.production" ]; then
    cat > backend/.env.production << 'EOF'
# Production Environment Variables
# Copy these to your Railway/hosting provider dashboard

NODE_ENV=production
PORT=3001

# Database (Railway will auto-inject DATABASE_URL)
# DATABASE_URL will be provided by Railway PostgreSQL plugin
DB_HOST=${PGHOST}
DB_PORT=${PGPORT}
DB_NAME=${PGDATABASE}
DB_USER=${PGUSER}
DB_PASSWORD=${PGPASSWORD}

# JWT (CHANGE THESE IN PRODUCTION!)
JWT_SECRET=CHANGE_THIS_TO_SECURE_RANDOM_STRING
JWT_EXPIRES_IN=7d

# CORS (Update with your Vercel URL after deployment)
CORS_ORIGIN=https://your-app.vercel.app

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
EOF
    echo -e "${GREEN}✓ Created .env.production template${NC}"
fi

echo ""

# Step 5: Commit all changes
echo -e "${BLUE}📝 Step 5: Committing Changes${NC}"
echo "=============================="
echo ""

git add .
git commit -m "feat: complete full-stack deployment configuration

- Frontend build optimized for Vercel
- Backend build configured for Railway
- Database connection setup for PostgreSQL
- Railway.json configuration
- Production environment templates
- Deployment automation scripts

Ready for:
✅ Frontend deployment to Vercel
✅ Backend deployment to Railway
✅ PostgreSQL database on Railway
✅ Full-stack integration"

echo -e "${GREEN}✓ Changes committed${NC}"
echo ""

git push origin main
echo -e "${GREEN}✓ Pushed to GitHub${NC}"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           Deployment Ready! 🚀                ║${NC}"
echo -e "${GREEN}╔═══════════════════════════════════════════════╗${NC}"
echo ""

# Show deployment instructions
cat << 'EOF'

📋 DEPLOYMENT INSTRUCTIONS
==========================

PART 1: Deploy Backend + Database (Railway)
-------------------------------------------

1. Go to: https://railway.app/new

2. Click "Deploy from GitHub repo"

3. Select: adrianstanca1/-Buildprogemini-

4. Configure:
   - Root Directory: backend
   - Build Command: npm install && npm run build
   - Start Command: npm start

5. Add PostgreSQL:
   - Click "New" → "Database" → "Add PostgreSQL"
   - Railway will auto-inject DATABASE_URL

6. Set Environment Variables:
   - JWT_SECRET: (generate secure random string)
   - CORS_ORIGIN: https://your-app.vercel.app (update after frontend deploy)
   - NODE_ENV: production

7. Deploy and note your Railway URL:
   Example: https://buildpro-backend.railway.app

8. Run migrations (one-time):
   - Go to Railway project settings
   - Add custom start command temporarily: npm run migrate && npm start
   - Or use Railway CLI: railway run npm run migrate

PART 2: Deploy Frontend (Vercel)
---------------------------------

1. Go to: https://vercel.com/new

2. Import repository: adrianstanca1/-Buildprogemini-

3. Configure:
   - Framework Preset: Vite
   - Root Directory: ./
   - Build Command: npm run build
   - Output Directory: dist

4. Add Environment Variable:
   - Name: VITE_API_URL
   - Value: https://your-railway-url.railway.app/api

5. Click "Deploy"

6. Note your Vercel URL:
   Example: https://buildpro.vercel.app

PART 3: Connect Frontend & Backend
-----------------------------------

1. Update Railway CORS_ORIGIN:
   - Go to Railway project variables
   - Set CORS_ORIGIN=https://your-vercel-url.vercel.app

2. Restart Railway deployment

3. Test the connection:
   - Visit your Vercel URL
   - Check browser console for errors
   - Test API calls

VERIFICATION CHECKLIST
---------------------

Frontend:
☐ Deployed to Vercel successfully
☐ VITE_API_URL environment variable set
☐ No build errors
☐ Pages load correctly

Backend:
☐ Deployed to Railway successfully
☐ PostgreSQL connected
☐ Migrations ran successfully
☐ Environment variables configured
☐ API responds to requests

Integration:
☐ Frontend can reach backend API
☐ CORS configured correctly
☐ Authentication works
☐ Database queries successful

QUICK DEPLOY COMMANDS
---------------------

# Railway CLI (alternative method)
npm install -g @railway/cli
railway login
railway init
railway up

# Vercel CLI (alternative method)
npm install -g vercel
vercel --prod

SUPPORT & DOCUMENTATION
-----------------------

- Frontend: VERCEL_DEPLOYMENT.md
- Backend: backend/DEPLOYMENT.md
- Full Guide: DEPLOYMENT_READY.md

URLs to bookmark:
- Railway Dashboard: https://railway.app/dashboard
- Vercel Dashboard: https://vercel.com/dashboard
- Your Backend: [Railway URL]/api/health
- Your Frontend: [Vercel URL]

EOF

echo ""
echo -e "${YELLOW}🎯 Next Steps:${NC}"
echo "1. Deploy backend to Railway (with PostgreSQL)"
echo "2. Deploy frontend to Vercel (with Railway API URL)"
echo "3. Update CORS settings in Railway"
echo "4. Test the full application"
echo ""
echo "All configuration files created and code committed!"
echo ""
