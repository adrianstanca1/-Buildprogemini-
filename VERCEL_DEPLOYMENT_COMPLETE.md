# 🚀 Complete Vercel Deployment Guide

## Deployment Status: ✅ Ready

Your BuildPro application is fully configured and ready for deployment to Vercel.

---

## ⚡ Quick Deploy (3 Steps)

### Step 1: Go to Vercel
Visit: **https://vercel.com/new**

### Step 2: Import Repository
1. Click "Import Git Repository"
2. Select: `adrianstanca1/-Buildprogemini-`
3. Click "Import"

### Step 3: Configure & Deploy
Vercel will auto-detect your settings from `vercel.json`. Just:

1. **Add Environment Variables:**
   ```
   DATABASE_URL = postgresql://postgres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres
   
   NODE_ENV = production
   
   JWT_SECRET = buildpro_jwt_secret_2025_production_key_secure_random_string
   
   CORS_ORIGIN = https://your-app.vercel.app
   ```

2. Click **"Deploy"** 🚀

---

## 📋 What Vercel Will Do Automatically

✅ Detect Vite framework  
✅ Run build command: `npm run build && cd backend && npm install && npm run build`  
✅ Set output directory: `dist`  
✅ Configure API routes to `/api/*`  
✅ Enable automatic deployments on push  

---

## 🔧 Alternative: Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Login to Vercel
vercel login

# Deploy to production
vercel --prod
```

When prompted:
- Set up and deploy? **Y**
- Which scope? **Select your account**
- Link to existing project? **N** (first time) or **Y** (subsequent)
- Project name? **buildpro** (or your choice)
- Directory? **./** (press Enter)
- Override settings? **N**

---

## 📝 Post-Deployment Steps

### 1. Update CORS Origin
After your first deployment:
1. Copy your Vercel URL (e.g., `https://buildpro-xyz.vercel.app`)
2. Go to: Vercel Dashboard → Your Project → Settings → Environment Variables
3. Update `CORS_ORIGIN` with your actual URL
4. Redeploy (Deployments tab → ... → Redeploy)

### 2. Verify Deployment
```bash
# Health check
curl https://your-app.vercel.app/api/v1/health

# Expected response:
{
  "status": "ok",
  "timestamp": "2025-11-21T...",
  "service": "BuildPro API"
}
```

### 3. Test Authentication
```bash
# Register a user
curl -X POST https://your-app.vercel.app/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "password": "test123"
  }'
```

---

## 🔐 Environment Variables Reference

| Variable | Value | Purpose |
|----------|-------|---------|
| `DATABASE_URL` | `postgresql://postgres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres` | Supabase PostgreSQL connection |
| `NODE_ENV` | `production` | Environment mode |
| `JWT_SECRET` | `buildpro_jwt_secret_2025_production_key_secure_random_string` | JWT token signing key |
| `CORS_ORIGIN` | `https://your-app.vercel.app` | Frontend URL (update after deploy) |
| `GEMINI_API_KEY` | (optional) | Google Gemini AI integration |

---

## 🗄️ Database Migrations

Migrations will run automatically on first API request. 

Or manually run:
```bash
# Via Vercel CLI
vercel env pull .env.production
cd backend
npm run migrate
npm run seed  # Optional: Add sample data
```

---

## 🔄 GitHub Actions Auto-Deployment

A GitHub Actions workflow has been created at `.github/workflows/deploy.yml`

To enable:
1. Go to: GitHub Repository → Settings → Secrets and variables → Actions
2. Add secrets:
   - `VERCEL_TOKEN` - Get from https://vercel.com/account/tokens
   - `VERCEL_ORG_ID` - Get from Vercel project settings
   - `VERCEL_PROJECT_ID` - Get from Vercel project settings

Then every push to `main` will auto-deploy! 🎉

---

## 📊 Build Configuration

Already configured in `vercel.json`:

```json
{
  "buildCommand": "npm run build && cd backend && npm install && npm run build",
  "outputDirectory": "dist",
  "installCommand": "npm install && cd backend && npm install",
  "framework": "vite"
}
```

Routes configured for:
- `/api/*` → Backend API
- `/assets/*` → Static assets (cached)
- `/*` → Frontend SPA

---

## 🆘 Troubleshooting

### Build fails
- Check build logs in Vercel dashboard
- Verify all dependencies in package.json
- Ensure backend builds successfully locally

### API returns 404
- Check environment variables are set
- Verify API routes in vercel.json
- Check backend/src/server.ts exports default

### Database connection fails
- Verify DATABASE_URL is correct
- Check Supabase connection pooling enabled
- Ensure SSL settings correct

### CORS errors
- Update CORS_ORIGIN with your Vercel URL
- Redeploy after updating

---

## ✅ Pre-Deployment Checklist

- ✅ Code committed and pushed to GitHub
- ✅ `vercel.json` configured
- ✅ Environment variables documented in `.env.vercel`
- ✅ Frontend builds successfully
- ✅ Backend builds successfully
- ✅ Database connection configured (Supabase)
- ✅ No TypeScript errors
- ✅ All routes configured

---

## 🎯 Next Steps After Deployment

1. **Update CORS_ORIGIN** with your Vercel URL
2. **Test all API endpoints** (use test-api.sh in backend/)
3. **Set up custom domain** (optional)
4. **Enable GitHub auto-deployments**
5. **Monitor logs** in Vercel dashboard
6. **Set up error tracking** (optional: Sentry, etc.)

---

## 🌐 Deployment URLs

After deployment, your app will be available at:
- **Production**: `https://your-project.vercel.app`
- **Preview**: Auto-generated for each push to non-main branches
- **API**: `https://your-project.vercel.app/api/v1/`

---

## 📚 Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Vite Deployment Guide](https://vitejs.dev/guide/static-deploy.html)
- [Supabase Docs](https://supabase.com/docs)
- Backend Deployment: `backend/DEPLOYMENT.md`
- Fixes Applied: `FIXES_APPLIED.md`

---

**Ready to deploy! Choose Quick Deploy above and launch in minutes! 🚀**
