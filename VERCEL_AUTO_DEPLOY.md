# 🚀 One-Click Vercel Deployment

## Automatic Deployment Setup

Your BuildPro app is configured for **automatic deployment** to Vercel!

### How It Works

1. **Push to GitHub** → Vercel automatically builds and deploys
2. **Environment Variables** → Set once in Vercel dashboard
3. **Database Migrations** → Run once after first deployment

---

## Step 1: Connect to Vercel (2 minutes)

### Option A: Click This Button

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https://github.com/adrianstanca1/-Buildprogemini-)

### Option B: Manual Import

1. Go to <https://vercel.com>
2. Click "Import Project"
3. Select your GitHub repository: `adrianstanca1/-Buildprogemini-`
4. Vercel auto-detects configuration from `vercel.json`

---

## Step 2: Add Environment Variables (3 minutes)

In Vercel Dashboard → Settings → Environment Variables, add:

### Required Variables

```bash
# Database (Get from Supabase - see Step 3)
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT].supabase.co:5432/postgres

# Security (Generate below)
JWT_SECRET=[paste generated secret]

# Environment
NODE_ENV=production

# CORS (Update after first deploy)
CORS_ORIGIN=https://your-project.vercel.app

# API URL (Update after first deploy)
VITE_API_URL=https://your-project.vercel.app/api
```

### Generate JWT Secret

Run this in your terminal:

```bash
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

Copy the output and paste as `JWT_SECRET`.

---

## Step 3: Create Supabase Database (3 minutes)

1. Go to <https://supabase.com>
2. Sign up with GitHub (free tier)
3. Click "New Project"
   - Name: `buildpro`
   - Database Password: Create a strong password
   - Region: Choose closest to you
4. Wait 2 minutes for provisioning
5. Go to Settings → Database
6. Copy "Connection string" (URI format)
7. Paste as `DATABASE_URL` in Vercel

---

## Step 4: Deploy

1. Click "Deploy" in Vercel
2. Wait ~2 minutes for build
3. Your app is live! 🎉

---

## Step 5: Update Environment Variables

After first deployment:

1. Copy your Vercel URL (e.g., `https://buildpro.vercel.app`)
2. Update in Vercel → Settings → Environment Variables:
   - `CORS_ORIGIN` → Your Vercel URL
   - `VITE_API_URL` → Your Vercel URL + `/api`
3. Redeploy (Deployments → Redeploy)

---

## Step 6: Run Database Migrations

Run migrations locally connecting to Supabase:

```bash
cd backend
npm install

# Set your Supabase DATABASE_URL
export DATABASE_URL="postgresql://postgres:..."

# Run migrations
npm run migrate

# Seed database with demo data (optional)
npm run seed
```

Or use Supabase SQL Editor:

1. Supabase Dashboard → SQL Editor
2. Copy SQL from `backend/src/config/migrations/`
3. Execute each migration

---

## ✅ Verification

### Test Your Deployment

```bash
# Health check
curl https://your-project.vercel.app/api/health

# Should return:
{"status":"ok","message":"BuildPro API is running"}
```

### Test in Browser

1. Visit your Vercel URL
2. Register a new account
3. Create a project
4. Try AI chat
5. Check browser console (F12) - should see no errors

---

## 🔄 Continuous Deployment

Now every time you push to GitHub:

1. ✅ Vercel automatically builds
2. ✅ Runs tests (if configured)
3. ✅ Deploys to production
4. ✅ Updates your live site

**No manual deployment needed!**

---

## 📊 What Gets Deployed

```
Vercel Deployment:
├── Frontend (React + Vite)
│   ├── Static files in /dist
│   ├── Served from edge CDN
│   └── Single-page app routing
│
└── Backend (Node.js API)
    ├── Serverless functions
    ├── Auto-scales
    └── /api/* endpoints

Database (Supabase):
└── PostgreSQL with connection pooling
```

---

## 🎯 Environment-Specific Settings

Vercel automatically sets:

- `VERCEL=1` (indicates Vercel environment)
- `VERCEL_ENV` (production/preview/development)
- `VERCEL_URL` (deployment URL)

Your app detects these and adjusts accordingly!

---

## 💡 Pro Tips

### Preview Deployments

- Every pull request gets a preview URL
- Test changes before merging
- Perfect for collaboration

### Production vs Preview

- `main` branch → Production deployment
- Other branches → Preview deployments
- Configure in Vercel settings

### Custom Domain

1. Vercel → Settings → Domains
2. Add your domain
3. Update DNS records
4. Update `CORS_ORIGIN` environment variable

---

## 🔧 Troubleshooting

### Build Fails

Check Vercel build logs:

- Deployment → View Function Logs
- Look for missing dependencies or TypeScript errors

### Database Connection Issues

Verify:

- `DATABASE_URL` is correct
- Supabase database is active
- Connection string includes password

### API Routes Not Working

Verify:

- `vercel.json` is in root directory
- Backend code is in `backend/src/`
- Environment variables are set

### CORS Errors

Update `CORS_ORIGIN`:

- Must match exact Vercel URL
- Include `https://`
- No trailing slash

---

## 📈 Monitoring

### Vercel Dashboard

- Real-time deployment status
- Function logs
- Performance metrics
- Error tracking

### Supabase Dashboard

- Database queries
- Connection pooling
- Storage usage
- Performance insights

---

## 💰 Cost

### Free Tier Includes

- **Vercel**: 100GB bandwidth/month, unlimited deployments
- **Supabase**: 500MB database, 1GB storage, 2GB bandwidth
- **Total**: $0/month for small projects

### When to Upgrade

- Vercel Pro ($20/mo): More bandwidth, team features
- Supabase Pro ($25/mo): More storage, backups, support

---

## 🎉 You're Done

Your app is now:

- ✅ Automatically deployed on every push
- ✅ Served from global edge network
- ✅ Connected to managed PostgreSQL
- ✅ Scaled automatically
- ✅ Production-ready!

**Just push your code and let Vercel handle the rest!**

---

## 🔗 Quick Links

- **Deploy Now**: <https://vercel.com/new>
- **Supabase**: <https://supabase.com>
- **Vercel Docs**: <https://vercel.com/docs>
- **Your Deployments**: <https://vercel.com/dashboard>

---

Need help? Check:

- `VERCEL_SUPABASE_DEPLOYMENT.md` - Detailed guide
- `PROJECT_OVERVIEW.md` - Project structure
- `backend/API_DOCUMENTATION.md` - API reference
