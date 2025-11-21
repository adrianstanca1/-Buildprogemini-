# 🚀 Quick Deploy to Vercel + Supabase

## TL;DR - 3 Steps to Deploy

### 1️⃣ Create Supabase Database

- Go to <https://supabase.com>
- Sign up → New Project → Copy connection string

### 2️⃣ Deploy to Vercel

- Go to <https://vercel.com>
- Import GitHub repo: `adrianstanca1/-Buildprogemini-`
- Add environment variables (see below)
- Deploy!

### 3️⃣ Run Migrations

```bash
cd backend
export DATABASE_URL="your_supabase_url"
npm run migrate
npm run seed
```

---

## Environment Variables for Vercel

Copy these to Vercel → Settings → Environment Variables:

```bash
DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT].supabase.co:5432/postgres
JWT_SECRET=[Run: node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"]
NODE_ENV=production
CORS_ORIGIN=https://your-project.vercel.app
VITE_API_URL=https://your-project.vercel.app/api
```

---

## Generate JWT Secret

Run this command:

```bash
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

Or use the script:

```bash
chmod +x generate-jwt-secret.sh
./generate-jwt-secret.sh
```

---

## What's Different from Railway?

✅ **Simpler**: No separate backend deployment  
✅ **Faster**: Vercel serverless functions  
✅ **Cheaper**: Both have generous free tiers  
✅ **Integrated**: Everything in one place  

---

## Full Guide

See `VERCEL_SUPABASE_DEPLOYMENT.md` for complete step-by-step instructions.

---

**Ready?** Go to <https://vercel.com> and click "Import Project"! 🎉

### Admin Accounts

- <admin@buildpro.com> / Admin123! (Super Admin)
- <company@buildpro.com> / Company123! (Company Admin)
- <supervisor@buildpro.com> / Super123! (Supervisor)
- <worker@buildpro.com> / Work123! (Operative)
