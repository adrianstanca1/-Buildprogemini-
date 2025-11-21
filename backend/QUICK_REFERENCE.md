# BuildPro Backend - Quick Reference

## 🚀 Quick Start Commands

```bash
# One-line setup (automated)
./setup-backend.sh

# Or manual setup
npm install && cp .env.example .env && docker-compose up -d && npm run migrate && npm run seed

# Start development
npm run dev

# Test API
./test-api.sh

# Check status
./check-status.sh
```

## 📍 API Endpoints

**Base URL**: `http://localhost:3001/api`

### Authentication

```bash
POST   /auth/register      # Register new user
POST   /auth/login         # Login user
GET    /auth/me            # Get current user (requires auth)
```

### Projects

```bash
GET    /projects           # Get all projects
GET    /projects/:id       # Get project by ID
POST   /projects           # Create project
PUT    /projects/:id       # Update project
DELETE /projects/:id       # Delete project
```

### Tasks

```bash
GET    /tasks              # Get all tasks
GET    /tasks/:id          # Get task by ID
POST   /tasks              # Create task
PUT    /tasks/:id          # Update task
DELETE /tasks/:id          # Delete task
```

### Team

```bash
GET    /team               # Get team members
POST   /team               # Add team member
PUT    /team/:id           # Update team member
DELETE /team/:id           # Remove team member
```

## 🔑 Test Credentials

```text
Admin:
  email: admin@buildpro.com
  password: Admin123!

Supervisor:
  email: supervisor@buildpro.com
  password: Super123!
```

## 💻 cURL Examples

**Register:**

```bash
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@test.com","password":"Pass123!","role":"admin"}'
```

**Login:**

```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@buildpro.com","password":"Admin123!"}'
```

**Get Projects (with auth):**

```bash
curl -X GET http://localhost:3001/api/projects \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Create Project:**

```bash
curl -X POST http://localhost:3001/api/projects \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -d '{"name":"New Building","location":"London","status":"active","startDate":"2025-01-01","budget":1000000}'
```

## 📦 npm Scripts

```bash
npm run dev          # Start dev server (hot reload)
npm run build        # Build TypeScript
npm start            # Start production server
npm run migrate      # Run database migrations
npm run seed         # Seed database
npm test             # Run tests (when configured)
```

## 🐳 Docker Commands

```bash
docker-compose up -d              # Start PostgreSQL
docker-compose down               # Stop PostgreSQL
docker-compose down -v            # Stop and remove data
docker-compose logs postgres      # View logs
docker exec -it buildpro-postgres psql -U postgres -d buildpro  # Connect to DB
```

## 🗄️ Database Tables

- `users` - User accounts
- `projects` - Construction projects
- `tasks` - Project tasks
- `team_members` - Team assignments
- `documents` - Project documents (schema only)
- `clients` - Client information (schema only)
- `inventory` - Equipment/materials (schema only)

## 🔧 Environment Variables

```env
PORT=3001                          # Server port
NODE_ENV=development               # Environment
DB_HOST=localhost                  # Database host
DB_PORT=5432                       # Database port
DB_NAME=buildpro                   # Database name
DB_USER=postgres                   # Database user
DB_PASSWORD=postgres               # Database password
JWT_SECRET=your_secret             # JWT secret
JWT_EXPIRES_IN=7d                  # Token expiry
CORS_ORIGIN=http://localhost:5173  # Frontend URL
```

## 🛠️ Troubleshooting

**Port in use:**

```bash
lsof -i :3001
kill -9 PID
```

**Database connection error:**

```bash
docker-compose restart
```

**Reset database:**

```bash
docker-compose down -v
docker-compose up -d
sleep 5
npm run migrate
npm run seed
```

**Clear and reinstall:**

```bash
rm -rf node_modules dist
npm install
npm run build
```

## 📚 Documentation Files

- `README.md` - Overview
- `QUICKSTART.md` - Setup guide
- `INTEGRATION_GUIDE.md` - Full integration
- `API_DOCUMENTATION.md` - API reference
- `DEPLOYMENT.md` - Deployment guide
- `INTEGRATION_STATUS.md` - Current status

## 🔐 Security Features

- ✓ JWT authentication
- ✓ Password hashing (bcrypt)
- ✓ Role-based access control
- ✓ Rate limiting (100 req/15min)
- ✓ Helmet security headers
- ✓ CORS protection
- ✓ Input validation

## 📊 Project Structure

```text
backend/
├── src/
│   ├── server.ts              # Main server
│   ├── config/                # Configuration
│   │   ├── database.ts
│   │   ├── logger.ts
│   │   ├── migrate.ts
│   │   └── seed.ts
│   ├── controllers/           # Business logic
│   ├── middleware/            # Express middleware
│   ├── models/                # Data models
│   └── routes/                # API routes
├── dist/                      # Compiled JS
├── logs/                      # Log files
├── .env                       # Environment config
├── docker-compose.yml         # Docker setup
└── package.json               # Dependencies
```

## 🎯 Common Tasks

**Add new endpoint:**

1. Create route in `src/routes/`
2. Add controller in `src/controllers/`
3. Add validation in `src/middleware/validation.ts`
4. Update API documentation

**Add database table:**

1. Add schema in `src/config/migrate.ts`
2. Create model in `src/models/`
3. Add seed data in `src/config/seed.ts`
4. Run migrations: `npm run migrate`

**Test manually:**

1. Start server: `npm run dev`
2. Use Postman, Insomnia, or cURL
3. Check logs in `logs/` directory

---

**Quick Help**: See `INTEGRATION_GUIDE.md` for detailed instructions
