# 🚀 Vercel + Supabase Deployment Guide

## Simple All-in-One Deployment

Deploy your full-stack BuildPro app using Vercel (frontend + API) and Supabase (PostgreSQL database).

## Step 1: Create Supabase Database (3 minutes)

1. **Go to:** <https://supabase.com>
2. **Sign up** with GitHub (free tier)
3. **Create new project:**
   - Name: `buildpro`
   - Database Password: [Create a strong password]
   - Region: Choose closest to your users
4. **Wait** for database to provision (~2 minutes)
5. **Get Connection String:**
   - Go to Project Settings → Database
   - Find "Connection string" → "URI"
   - Copy the connection string (it looks like: `postgresql://postgres:[password]@db.[project].supabase.co:5432/postgres`)

## Step 2: Run Database Migrations

You can run migrations locally connecting to Supabase:

```bash
# Install dependencies
cd backend
npm install

# Set DATABASE_URL temporarily
export DATABASE_URL="your_supabase_connection_string"

# Run migrations
npm run migrate

# Seed database (optional)
npm run seed
```

Or use Supabase SQL Editor:

1. Go to Supabase Dashboard → SQL Editor
2. Copy and paste the migration files from `backend/src/config/migrations/`
3. Execute each migration

## Step 3: Deploy to Vercel (2 minutes)

1. **Go to:** <https://vercel.com>
2. **Sign in** with GitHub
3. **Import project:** `adrianstanca1/-Buildprogemini-`
4. **Add Environment Variables:**

   ```
   DATABASE_URL=postgresql://postgres:[password]@db.[project].supabase.co:5432/postgres
   NODE_ENV=production
   JWT_SECRET=[generate with: node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"]
   CORS_ORIGIN=https://your-project.vercel.app
   VITE_API_URL=https://your-project.vercel.app/api
   ```

5. **Deploy!**

## Step 4: Update Frontend API URL

After deployment, update the environment variable:

1. Vercel Dashboard → Your Project → Settings → Environment Variables
2. Update `VITE_API_URL` to your actual Vercel URL
3. Redeploy (Vercel → Deployments → Redeploy)

## Environment Variables Summary

### Required Variables in Vercel

| Variable | Example Value | Where to Get It |
|----------|---------------|-----------------|
| `DATABASE_URL` | `postgresql://postgres:pass@db.xxx.supabase.co:5432/postgres` | Supabase Dashboard → Settings → Database |
| `JWT_SECRET` | `[64-char random string]` | Generate: `node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"` |
| `NODE_ENV` | `production` | Static value |
| `CORS_ORIGIN` | `https://buildpro.vercel.app` | Your Vercel URL |
| `VITE_API_URL` | `https://buildpro.vercel.app/api` | Your Vercel URL + /api |

## Testing Your Deployment

### 1. Test Health Endpoint

```bash
curl https://your-project.vercel.app/api/health
```

Expected response:

```json
{"status":"ok","message":"BuildPro API is running"}
```

### 2. Test User Registration

```bash
curl -X POST https://your-project.vercel.app/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123","name":"Test User"}'
```

### 3. Open Frontend

Visit `https://your-project.vercel.app` and try:

- ✅ Register/Login
- ✅ Create a project
- ✅ View dashboard
- ✅ Use AI chat

## Supabase Features You Can Use

### Database Dashboard

- View tables and data in real-time
- Run SQL queries
- Monitor performance

### Authentication (Optional Upgrade)

Supabase has built-in auth you could integrate later:

- Social login (Google, GitHub, etc.)
- Magic links
- Row-level security

### Storage (Optional)

For file uploads (documents, images):

- Free 1GB storage
- CDN integration
- Access control

## Cost

### Free Tier Limits

- **Vercel**: Unlimited deployments, 100GB bandwidth/month
- **Supabase**: 500MB database, 1GB storage, 2GB bandwidth
- **Total**: $0/month for small projects

### Paid Tier (if you grow)

- **Vercel Pro**: $20/month
- **Supabase Pro**: $25/month
- **Total**: $45/month

## Troubleshooting

### "Database connection failed"

- Verify `DATABASE_URL` is correct in Vercel environment variables
- Check Supabase database is active (not paused)
- Ensure SSL is enabled in connection string

### "CORS error"

- Update `CORS_ORIGIN` to exact Vercel URL
- Redeploy after changing environment variables

### "API routes not working"

- Verify `vercel.json` is in root directory
- Check backend code is in `backend/` folder
- Redeploy

## Database Management

### View Data

Supabase Dashboard → Table Editor

### Run Queries

Supabase Dashboard → SQL Editor

### Backup Database

```bash
# Using pg_dump
pg_dump "your_supabase_connection_string" > backup.sql
```

### Restore Database

```bash
psql "your_supabase_connection_string" < backup.sql
```

## Monitoring

### Application Logs

Vercel Dashboard → Your Project → Deployments → View Function Logs

### Database Metrics

Supabase Dashboard → Database → Usage

### Performance

Vercel Analytics (optional add-on)

## Scaling

Both platforms auto-scale:

- **Vercel**: Automatic edge caching and CDN
- **Supabase**: Connection pooling included

## Next Steps

1. ✅ Set up custom domain (optional)
2. ✅ Enable Vercel Analytics
3. ✅ Configure Supabase backups
4. ✅ Set up monitoring/alerts
5. ✅ Add production logging

## Support

- **Vercel Docs**: <https://vercel.com/docs>
- **Supabase Docs**: <https://supabase.com/docs>
- **PostgreSQL Docs**: <https://www.postgresql.org/docs/>

---

**That's it!** Your full-stack app is deployed with:

- ✅ Frontend on Vercel edge network
- ✅ Backend API on Vercel serverless functions
- ✅ PostgreSQL database on Supabase
- ✅ All integrated and working together
