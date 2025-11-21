# 🚀 BuildPro - Complete Full-Stack Deployment Guide

## Overview

This guide will help you deploy the complete BuildPro application with:

- ✅ **Frontend**: React app on Vercel
- ✅ **Backend**: Node.js API on Railway
- ✅ **Database**: PostgreSQL on Railway
- ✅ **Full Integration**: Working database connections and API

## Architecture

```
┌─────────────┐         ┌──────────────┐         ┌─────────────┐
│   Vercel    │   →     │   Railway    │   →     │ PostgreSQL  │
│  (Frontend) │  HTTPS  │  (Backend)   │   DB    │ (Database)  │
└─────────────┘         └──────────────┘         └─────────────┘
```

## Prerequisites

- GitHub account
- Vercel account (free tier)
- Railway account (free tier with $5 credit)
- Your repository pushed to GitHub

## Part 1: Deploy Backend + Database (Railway)

### Step 1: Create Railway Account

1. Go to <https://railway.app>
2. Sign up with GitHub
3. Authorize Railway to access your repositories

### Step 2: Create New Project

1. Click **"New Project"**
2. Select **"Deploy from GitHub repo"**
3. Choose repository: `adrianstanca1/-Buildprogemini-`
4. Railway will detect Node.js automatically

### Step 3: Add PostgreSQL Database

1. In your Railway project, click **"New"**
2. Select **"Database"**
3. Choose **"Add PostgreSQL"**
4. Railway will:
   - Create PostgreSQL instance
   - Auto-inject `DATABASE_URL` environment variable
   - Provide individual connection variables (`PGHOST`, `PGPORT`, etc.)

### Step 4: Configure Backend Service

1. Click on your backend service (the GitHub repo deployment)
2. Go to **"Settings"** → **"Root Directory"**
3. Set to: `backend`
4. Go to **"Settings"** → **"Build"**
   - Build Command: `npm install && npm run build`
   - Start Command: `npm start`

### Step 5: Set Environment Variables

In Railway project → Backend service → **"Variables"**:

```bash
NODE_ENV=production
PORT=3001

# JWT Secret - Generate with: node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
JWT_SECRET=your_generated_secret_here

# CORS - Update after Vercel deployment
CORS_ORIGIN=https://your-app.vercel.app

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100

# Database will be auto-injected by Railway PostgreSQL plugin
# DATABASE_URL, PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD
```

### Step 6: Deploy Backend

1. Railway will automatically deploy
2. Wait for deployment to complete (~2-3 minutes)
3. Your backend will be available at: `https://[your-project].up.railway.app`

### Step 7: Run Database Migrations

**Option A: Using Railway CLI (Recommended)**

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Link to your project
railway link

# Run migrations
railway run npm run migrate --dir backend

# Seed database (optional)
railway run npm run seed --dir backend
```

**Option B: Temporary Start Command**

1. Go to Railway → Backend service → Settings → Deploy
2. Temporarily change Start Command to: `npm run migrate && npm run seed && npm start`
3. Redeploy
4. After successful deployment, change back to: `npm start`

### Step 8: Test Backend

Test your Railway backend:

```bash
curl https://your-project.up.railway.app/api/health
```

Should return:

```json
{"status":"ok","message":"BuildPro API is running"}
```

---

## Part 2: Deploy Frontend (Vercel)

### Step 1: Create Vercel Account

1. Go to <https://vercel.com>
2. Sign up with GitHub
3. Authorize Vercel

### Step 2: Import Project

1. Click **"Add New..."** → **"Project"**
2. Import Git Repository: `adrianstanca1/-Buildprogemini-`
3. Vercel will auto-detect Vite configuration

### Step 3: Configure Build Settings

Verify settings (should be auto-detected):

- **Framework Preset**: Vite
- **Root Directory**: `./`
- **Build Command**: `npm run build`
- **Output Directory**: `dist`
- **Install Command**: `npm install`

### Step 4: Add Environment Variables

In Vercel project settings → **"Environment Variables"**:

```bash
# Add your Railway backend URL
VITE_API_URL=https://your-project.up.railway.app/api
```

**Important**: Replace `your-project.up.railway.app` with your actual Railway URL!

### Step 5: Deploy Frontend

1. Click **"Deploy"**
2. Wait for deployment (~2 minutes)
3. Your frontend will be available at: `https://your-project.vercel.app`

---

## Part 3: Connect Frontend & Backend

### Step 1: Update CORS in Railway

1. Go to Railway → Backend service → **"Variables"**
2. Update `CORS_ORIGIN`:

   ```bash
   CORS_ORIGIN=https://your-project.vercel.app
   ```

3. Replace with your actual Vercel URL
4. Railway will automatically redeploy

### Step 2: Verify Connection

1. Visit your Vercel URL
2. Open browser DevTools (F12) → Console
3. Try to login or make API calls
4. Check for CORS errors or network issues

### Step 3: Test Full Application

Test these features:

- ✅ Login/Register (tests database connection)
- ✅ View projects (tests API + database queries)
- ✅ Create project (tests write operations)
- ✅ View tasks (tests relationships)
- ✅ AI Chat (tests Gemini API integration)

---

## Database Management

### Access Database

**Option 1: Railway Dashboard**

- Go to Railway → PostgreSQL service → **"Data"**
- Browse tables and run queries

**Option 2: Railway CLI**

```bash
railway connect
# Opens psql connection to your database
```

**Option 3: External Client**
Get connection details from Railway → PostgreSQL → **"Connect"**:

```bash
psql postgresql://user:pass@host:port/database
```

### Run Migrations

```bash
railway run npm run migrate --dir backend
```

### Seed Database

```bash
railway run npm run seed --dir backend
```

### Backup Database

```bash
railway run pg_dump $DATABASE_URL > backup.sql
```

---

## Environment Variables Reference

### Frontend (Vercel)

| Variable | Value | Description |
|----------|-------|-------------|
| `VITE_API_URL` | `https://your-railway.app/api` | Backend API URL |

### Backend (Railway)

| Variable | Value | Description |
|----------|-------|-------------|
| `NODE_ENV` | `production` | Environment |
| `PORT` | `3001` | Server port |
| `JWT_SECRET` | `[random string]` | JWT signing secret |
| `CORS_ORIGIN` | `https://your-vercel.app` | Frontend URL |
| `DATABASE_URL` | Auto-injected by Railway | PostgreSQL connection |
| `RATE_LIMIT_WINDOW_MS` | `900000` | Rate limit window |
| `RATE_LIMIT_MAX_REQUESTS` | `100` | Max requests per window |

---

## Verification Checklist

### ✅ Backend Deployment

- [ ] Railway project created
- [ ] PostgreSQL database added
- [ ] Environment variables set
- [ ] Backend deployed successfully
- [ ] Migrations completed
- [ ] Database seeded (optional)
- [ ] Health endpoint responds
- [ ] Can query database

### ✅ Frontend Deployment

- [ ] Vercel project created
- [ ] `VITE_API_URL` environment variable set
- [ ] Frontend deployed successfully
- [ ] Static assets loading
- [ ] No build errors

### ✅ Integration

- [ ] Frontend can reach backend
- [ ] CORS configured correctly
- [ ] Authentication works
- [ ] Database queries successful
- [ ] API calls returning data
- [ ] No console errors

---

## Troubleshooting

### Backend Issues

**Database Connection Error**

```bash
# Check DATABASE_URL is set
railway vars

# Test connection
railway run npm run migrate --dir backend
```

**CORS Error**

- Ensure `CORS_ORIGIN` matches your Vercel URL exactly
- Include protocol: `https://`
- No trailing slash

**Migrations Not Running**

```bash
# Manually run migrations
railway run npm run migrate --dir backend

# Check database tables
railway connect
\dt
```

### Frontend Issues

**API Calls Failing**

- Check `VITE_API_URL` is set correctly
- Verify backend is deployed and running
- Test backend directly: `curl https://your-railway.app/api/health`

**Environment Variable Not Loading**

- Redeploy after adding variables
- Vercel requires redeploy for new env vars

**Build Errors**

- Check build logs in Vercel dashboard
- Ensure all dependencies in `package.json`

### Database Issues

**Tables Not Created**

```bash
# Run migrations
railway run npm run migrate --dir backend
```

**Connection Pool Exhausted**

- Check for unclosed connections in code
- Railway free tier has connection limits

---

## Monitoring & Logs

### Railway Logs

```bash
# View logs
railway logs

# Follow logs
railway logs --follow
```

### Vercel Logs

- Go to Vercel Dashboard → Your Project → **"Logs"**
- Real-time logs available

### Database Metrics

- Railway Dashboard → PostgreSQL → **"Metrics"**
- View connections, queries, storage

---

## Scaling & Performance

### Railway

- **Free Tier**: $5 credit/month, 512MB RAM
- **Upgrade**: $20/month for 8GB RAM
- Auto-scaling available on paid plans

### Vercel

- **Free Tier**: Unlimited deployments
- **Bandwidth**: 100GB/month
- Automatic edge caching

### Database

- **Free Tier**: 256MB storage
- **Upgrade**: $5/month for 1GB
- Automatic backups on paid plans

---

## Custom Domains

### Vercel (Frontend)

1. Go to Project Settings → **"Domains"**
2. Add your custom domain
3. Update DNS records as instructed

### Railway (Backend)

1. Go to Backend service → **"Settings"** → **"Domains"**
2. Add custom domain
3. Update DNS records
4. Update `CORS_ORIGIN` and `VITE_API_URL`

---

## Security Checklist

- [ ] Change `JWT_SECRET` to random string
- [ ] Enable HTTPS only (automatic on both platforms)
- [ ] Set proper `CORS_ORIGIN`
- [ ] Use environment variables for secrets
- [ ] Enable rate limiting
- [ ] Regular database backups
- [ ] Monitor logs for suspicious activity

---

## Cost Estimation

### Free Tier (Both Services)

- **Vercel**: Free forever for personal projects
- **Railway**: $5 credit/month (enough for small apps)
- **Total**: $0-5/month

### Paid Tier (Production)

- **Vercel Pro**: $20/month
- **Railway Developer**: $20/month
- **PostgreSQL**: $5/month
- **Total**: ~$45/month

---

## Quick Deploy Commands

### Deploy Backend

```bash
# Using Railway CLI
railway up
```

### Deploy Frontend

```bash
# Using Vercel CLI
vercel --prod
```

### Run Migrations

```bash
railway run npm run migrate --dir backend
```

---

## Support & Resources

- **Railway Docs**: <https://docs.railway.app>
- **Vercel Docs**: <https://vercel.com/docs>
- **PostgreSQL Docs**: <https://www.postgresql.org/docs/>
- **Project Docs**: See `backend/DEPLOYMENT.md`

---

## Success! 🎉

Your BuildPro application is now fully deployed with:

- ✅ Frontend on Vercel
- ✅ Backend on Railway
- ✅ PostgreSQL database on Railway
- ✅ Full integration working

**Frontend URL**: `https://your-project.vercel.app`  
**Backend API**: `https://your-project.up.railway.app/api`  
**Database**: Managed by Railway

---

**Next Steps**:

1. Test all features
2. Add custom domain (optional)
3. Monitor logs and metrics
4. Set up backups
5. Share with users!
