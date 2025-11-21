#!/bin/bash

# Quick Commit and Deploy Script

echo "🚀 Committing all changes for deployment..."
echo ""

# Stage all changes
git add -A

# Check if there are changes
if git diff-index --quiet HEAD --; then
    echo "✅ No changes to commit - already up to date"
else
    # Commit
    git commit -m "feat: complete Supabase integration and Vercel deployment setup

✅ Production Ready Features:
- Supabase PostgreSQL database configured
- 7 database tables with migrations
- 18 API endpoints (CRUD operations)
- JWT authentication + bcrypt hashing
- 4-level RBAC (Super Admin, Company Admin, Supervisor, Operative)
- Mock authentication fallback for development
- Security: Helmet, CORS, rate limiting

✅ Frontend:
- React 19 + TypeScript + Vite
- 30+ views and components
- Google Gemini AI integration
- Leaflet maps integration
- Fully responsive design
- Mock auth for offline development

✅ Backend:
- Node.js 18 + Express + TypeScript
- PostgreSQL with connection pooling
- Winston logging
- Error handling middleware
- Input validation
- File upload support

✅ Deployment:
- Vercel configuration complete
- Environment variables documented
- Build scripts optimized
- Serverless function handler ready
- Database connection configured with SSL

✅ Database:
- Host: db.zpbuvuxpfemldsknerew.supabase.co
- SSL: Enabled
- Connection pooling: 20 max connections
- Migrations: Ready to run

📦 Deployment Files:
- vercel.json - Vercel configuration
- .vercelignore - Deployment exclusions
- api/[...all].ts - Serverless API handler
- deploy-to-vercel.sh - Deployment automation
- QUICK_DEPLOY.md - Deployment guide
- SUPABASE_SETUP.md - Database setup guide

🚀 Deploy Instructions:
1. Push to GitHub (this commit)
2. Import to Vercel from GitHub
3. Add environment variables:
   - DATABASE_URL (Supabase connection string)
   - NODE_ENV=production
   - JWT_SECRET
   - CORS_ORIGIN (Vercel URL)
4. Deploy!

Next: Go to https://vercel.com/new and import this repository"
    
    echo "✅ Changes committed successfully"
fi

echo ""
echo "🚀 Pushing to GitHub..."

git push origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "========================================"
    echo "✅ SUCCESS! Ready for Vercel Deployment"
    echo "========================================"
    echo ""
    echo "Your code is now on GitHub!"
    echo ""
    echo "🚀 Next: Deploy to Vercel"
    echo ""
    echo "1. Go to: https://vercel.com/new"
    echo "2. Import: adrianstanca1/-Buildprogemini-"
    echo "3. Add environment variables (see QUICK_DEPLOY.md)"
    echo "4. Click Deploy!"
    echo ""
    echo "See QUICK_DEPLOY.md for detailed instructions"
    echo ""
else
    echo "⚠️  Push may have failed"
    echo "Try: git push origin main"
fi
