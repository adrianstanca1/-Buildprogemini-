# 🚀 BuildPro Deployment Guide

**Status:** ✅ Production Ready

---

## Quick Deploy (5 Minutes)

### Option 1: Vercel Dashboard (Easiest)

1. **Go to:** https://vercel.com/new
2. **Import:** `adrianstanca1/-Buildprogemini-`
3. **Add Environment Variables:**
   ```
   DATABASE_URL=postgresql://postgres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres
   NODE_ENV=production
   JWT_SECRET=buildpro_jwt_secret_2025_production_key_secure_random_string
   CORS_ORIGIN=https://your-app.vercel.app
   ```
4. **Deploy** 🚀

### Option 2: CLI Deploy

```bash
chmod +x deploy.sh
./deploy.sh
```

### Option 3: Quick Deploy

```bash
chmod +x deploy-now.sh
./deploy-now.sh
```

---

## Environment Variables

Required for Vercel deployment:

| Variable | Value | Purpose |
|----------|-------|---------|
| `DATABASE_URL` | `postgresql://postgres.zpbuvuxpfemldsknerew:%20...` | Supabase PostgreSQL |
| `NODE_ENV` | `production` | Environment |
| `JWT_SECRET` | `buildpro_jwt_secret_2025...` | JWT signing |
| `CORS_ORIGIN` | `https://your-app.vercel.app` | Frontend URL |

---

## Post-Deployment

1. Update `CORS_ORIGIN` with actual Vercel URL
2. Redeploy
3. Test: `https://your-app.vercel.app/api/v1/health`

---

## Troubleshooting

- **Build fails:** Check Vercel logs
- **API 404:** Verify environment variables
- **CORS errors:** Update CORS_ORIGIN

---

## Documentation

- **Backend Guide:** [backend/DEPLOYMENT.md](./backend/DEPLOYMENT.md)
- **Fixes Log:** [FIXES_APPLIED.md](./FIXES_APPLIED.md)
- **Quick Guide:** [QUICK_DEPLOY_GUIDE.md](./QUICK_DEPLOY_GUIDE.md)

---

**Ready to deploy! 🚀**
