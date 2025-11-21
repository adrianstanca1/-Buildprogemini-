# Supabase Database Setup Complete! 🎉

Your Supabase PostgreSQL database is now configured and ready to use.

## ✅ Configuration Status

**Database Connection:**

- **Host:** `db.zpbuvuxpfemldsknerew.supabase.co`
- **Database:** `postgres`
- **Port:** `5432`
- **SSL:** Enabled (required for Supabase)
- **Status:** ✅ Configured in `backend/.env`

**Environment Variables:**

```env
DATABASE_URL=postgresql://postgres:%20Cumparavinde1%5D@db.zpbuvuxpfemldsknerew.supabase.co:5432/postgres
```

## 🚀 Quick Start

### 1. Test Database Connection

```bash
chmod +x test-supabase.sh
./test-supabase.sh
```

### 2. Setup Database (Migrate & Seed)

```bash
cd backend
chmod +x supabase-setup.sh
./supabase-setup.sh
```

This will:

- ✅ Install dependencies
- ✅ Test connection
- ✅ Create 7 database tables
- ✅ Seed with test data (7 users, projects, tasks, etc.)

### 3. Start Backend Server

```bash
cd backend
npm run dev
```

Server will run at: `http://localhost:3001`

## 📋 Database Schema (7 Tables)

Your Supabase database will have these tables:

1. **users** - User accounts with authentication
2. **projects** - Construction projects
3. **tasks** - Project tasks
4. **team_members** - Team member profiles
5. **documents** - Project documents
6. **clients** - Client information
7. **inventory** - Equipment and materials

## 🔐 Test Accounts (After Seeding)

```
Super Admin:
  Email: admin@buildpro.com
  Password: Admin123!

Company Admin:
  Email: company@buildpro.com
  Password: Company123!

Supervisor:
  Email: supervisor@buildpro.com
  Password: Super123!

Operative:
  Email: worker@buildpro.com
  Password: Work123!
```

## 🛠️ Available Commands

```bash
# Test connection
./test-supabase.sh

# Full setup (migrate + seed)
cd backend && ./supabase-setup.sh

# Start dev server
cd backend && npm run dev

# Run migrations only
cd backend && npm run migrate

# Seed data only
cd backend && npm run seed

# Test API endpoints
cd backend && make check-api

# Run tests
cd backend && npm test
```

## 📍 Vercel Deployment Configuration

For Vercel deployment, add these environment variables:

**Vercel Dashboard → Your Project → Settings → Environment Variables:**

```
DATABASE_URL = postgresql://postgres:%20Cumparavinde1%5D@db.zpbuvuxpfemldsknerew.supabase.co:5432/postgres
NODE_ENV = production
JWT_SECRET = buildpro_jwt_secret_2025_production_key_secure_random_string
CORS_ORIGIN = https://your-app.vercel.app
```

## 🔧 Supabase Dashboard Access

**Direct SQL Access:**

1. Go to <https://supabase.com/dashboard>
2. Select your project
3. Go to **SQL Editor**
4. Run any SQL queries directly

**View Tables:**

1. Go to **Table Editor**
2. Browse all 7 tables
3. View, edit, or delete data

**Database Settings:**

- Navigate to **Settings → Database**
- Find connection pooling, extensions, and backups

## 📊 Connection Info

The database configuration automatically:

- ✅ Uses SSL for secure connections
- ✅ Handles connection pooling (max 20 connections)
- ✅ Sets up error handling and logging
- ✅ Configures for both dev and production

**Connection Details in Code:**
Located in `backend/src/config/database.ts`

## ⚡ Next Steps

1. **Test Connection:**

   ```bash
   ./test-supabase.sh
   ```

2. **Setup Database:**

   ```bash
   cd backend && ./supabase-setup.sh
   ```

3. **Start Backend:**

   ```bash
   cd backend && npm run dev
   ```

4. **Test API:**

   ```bash
   cd backend && make check-api
   ```

5. **Deploy to Vercel:**
   - Push to GitHub
   - Import to Vercel
   - Add environment variables
   - Deploy!

## 🐛 Troubleshooting

**Connection Failed:**

- Check Supabase project is active in dashboard
- Verify DATABASE_URL in `backend/.env`
- Ensure IP is not blocked (Supabase allows all by default)

**Migration Errors:**

- Tables might already exist - safe to ignore
- Drop tables in Supabase SQL Editor if needed:

  ```sql
  DROP TABLE IF EXISTS inventory, documents, clients, team_members, tasks, projects, users CASCADE;
  ```

**Permission Errors:**

- Supabase postgres user has full permissions
- If issues, check project settings in Supabase dashboard

## 📚 Resources

- **Supabase Dashboard:** <https://supabase.com/dashboard>
- **API Documentation:** `backend/API_DOCUMENTATION.md`
- **Integration Guide:** `backend/INTEGRATION_GUIDE.md`
- **Quick Reference:** `backend/QUICK_REFERENCE.md`

---

**Your BuildPro backend is ready for Supabase! 🎉**

Run `./test-supabase.sh` to verify connection now.
