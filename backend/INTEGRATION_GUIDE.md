# Backend Integration Guide

This guide provides step-by-step instructions for integrating and running the BuildPro backend.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quick Start](#quick-start)
3. [Manual Setup](#manual-setup)
4. [Testing the API](#testing-the-api)
5. [Frontend Integration](#frontend-integration)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v18 or higher) - [Download here](https://nodejs.org/)
- **npm** (v9 or higher) - Comes with Node.js
- **Docker** & **Docker Compose** - [Download here](https://docs.docker.com/get-docker/)
- **Git** - [Download here](https://git-scm.com/)

Verify installations:

```bash
node -v    # Should show v18.x or higher
npm -v     # Should show v9.x or higher
docker -v  # Should show Docker version
```

---

## Quick Start

### Option 1: Automated Setup (Recommended)

Run the automated setup script:

```bash
cd backend
chmod +x setup-backend.sh
./setup-backend.sh
```

This script will:

- ✓ Install all dependencies
- ✓ Create `.env` configuration file
- ✓ Start PostgreSQL database
- ✓ Run migrations
- ✓ Seed database with test data
- ✓ Build the application

### Option 2: Manual Setup

Follow the [Manual Setup](#manual-setup) section below.

---

## Manual Setup

### Step 1: Install Dependencies

```bash
cd backend
npm install
```

This installs all required packages:

- Express.js - Web framework
- PostgreSQL driver - Database connectivity
- JWT & bcrypt - Authentication
- Winston - Logging
- And more...

### Step 2: Configure Environment

Create a `.env` file from the template:

```bash
cp .env.example .env
```

Edit `.env` if needed (default values work for local development):

```env
# Server
PORT=3001
NODE_ENV=development

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=buildpro
DB_USER=postgres
DB_PASSWORD=postgres

# JWT
JWT_SECRET=buildpro_secret_key_dev_only_change_in_production
JWT_EXPIRES_IN=7d

# CORS
CORS_ORIGIN=http://localhost:5173
```

### Step 3: Start PostgreSQL Database

Using Docker Compose:

```bash
docker-compose up -d
```

This starts a PostgreSQL container with:

- Database: `buildpro`
- Username: `postgres`
- Password: `postgres`
- Port: `5432`

Verify the database is running:

```bash
docker ps | grep buildpro-postgres
```

### Step 4: Run Database Migrations

Create the database schema:

```bash
npm run migrate
```

This creates the following tables:

- `users` - User accounts and authentication
- `projects` - Construction projects
- `tasks` - Project tasks and assignments
- `team_members` - Project team assignments
- `documents` - Project documents (schema only)
- `clients` - Client information (schema only)
- `inventory` - Equipment and materials (schema only)

### Step 5: Seed Database

Populate with test data:

```bash
npm run seed
```

This creates:

- 2 admin users
- 2 supervisors
- 3 operatives
- 2 sample projects
- Multiple tasks
- Team assignments

**Default Test Credentials:**

```text
Admin User:
  Email: admin@buildpro.com
  Password: Admin123!

Supervisor:
  Email: supervisor@buildpro.com
  Password: Super123!
```

### Step 6: Build TypeScript

Compile TypeScript to JavaScript:

```bash
npm run build
```

Output is in the `dist/` folder.

### Step 7: Start the Server

For development (with hot reload):

```bash
npm run dev
```

For production:

```bash
npm start
```

The API server will start on `http://localhost:3001`

---

## Testing the API

### Option 1: Automated API Tests

Run the test script:

```bash
chmod +x test-api.sh
./test-api.sh
```

This tests:

- ✓ Health check
- ✓ User registration
- ✓ User login
- ✓ Authentication
- ✓ Project CRUD operations
- ✓ Task management
- ✓ Team management

### Option 2: Manual Testing with cURL

**Health Check:**

```bash
curl http://localhost:3001/api/health
```

**Register User:**

```bash
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "SecurePass123!",
    "role": "admin"
  }'
```

**Login:**

```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "SecurePass123!"
  }'
```

Save the token from the response and use it for authenticated requests:

**Get Projects:**

```bash
curl -X GET http://localhost:3001/api/projects \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### Option 3: Using Postman or Insomnia

1. Import the API endpoints from `API_DOCUMENTATION.md`
2. Set base URL: `http://localhost:3001/api`
3. For authenticated endpoints, add header:

   ```text
   Authorization: Bearer YOUR_TOKEN
   ```

---

## Frontend Integration

### Update Frontend API Configuration

Edit the frontend `.env` file:

```env
VITE_API_URL=http://localhost:3001/api
```

### Connect AuthContext to Backend

The `AuthContext` is already configured to use the backend:

```typescript
// contexts/AuthContext.tsx
const login = async (credentials: LoginCredentials): Promise<void> => {
  const response = await authService.login(credentials);
  setUser(response.user);
};
```

### Using the API Client

The frontend includes a pre-configured API client:

```typescript
// Example usage in a component
import { apiClient } from '../services/api';

// Get projects
const projects = await apiClient.get('/projects');

// Create project
const newProject = await apiClient.post('/projects', {
  name: 'New Building',
  location: 'London',
  status: 'active'
});
```

### Starting Both Frontend and Backend

**Terminal 1 - Backend:**

```bash
cd backend
npm run dev
```

**Terminal 2 - Frontend:**

```bash
cd ..
npm run dev
```

Access the app at `http://localhost:5173`

---

## Troubleshooting

### Database Connection Issues

**Problem:** Cannot connect to PostgreSQL

**Solution:**

```bash
# Check if container is running
docker ps | grep buildpro-postgres

# Restart container
docker-compose down
docker-compose up -d

# Check container logs
docker logs buildpro-postgres
```

### Port Already in Use

**Problem:** Port 3001 is already in use

**Solution:**

```bash
# Find process using port 3001
lsof -i :3001

# Kill the process
kill -9 PID

# Or change port in .env
PORT=3002
```

### Migration Errors

**Problem:** Migration fails

**Solution:**

```bash
# Reset database
docker-compose down -v
docker-compose up -d

# Wait for PostgreSQL to start
sleep 5

# Run migrations again
npm run migrate
```

### Authentication Issues

**Problem:** JWT token invalid

**Solution:**

- Check `JWT_SECRET` in `.env` matches between sessions
- Token expires after 7 days by default
- Register a new user or login again

### CORS Errors

**Problem:** Frontend cannot access API

**Solution:**

- Check `CORS_ORIGIN` in backend `.env`
- Should match frontend URL (default: `http://localhost:5173`)
- Restart backend after changing `.env`

### TypeScript Build Errors

**Problem:** Build fails with type errors

**Solution:**

```bash
# Clean and reinstall
rm -rf node_modules dist
npm install
npm run build
```

### Database Schema Out of Sync

**Problem:** Database doesn't match expected schema

**Solution:**

```bash
# Recreate database
docker-compose down -v
docker-compose up -d
sleep 5
npm run migrate
npm run seed
```

---

## Useful Commands

### Development

```bash
npm run dev        # Start dev server with hot reload
npm run build      # Build TypeScript
npm start          # Start production server
```

### Database

```bash
npm run migrate    # Run migrations
npm run seed       # Seed database
```

### Docker

```bash
docker-compose up -d           # Start database
docker-compose down            # Stop database
docker-compose down -v         # Stop and remove volumes
docker-compose logs postgres   # View logs
```

### Testing

```bash
./test-api.sh      # Run API tests
npm test           # Run Jest tests (when configured)
```

---

## Next Steps

1. ✓ Backend is running
2. ✓ Database is seeded
3. ✓ API endpoints are working
4. → Start the frontend and test end-to-end integration
5. → Implement remaining features (documents, clients, inventory)
6. → Add comprehensive unit tests
7. → Deploy to production

For API endpoint documentation, see [API_DOCUMENTATION.md](./API_DOCUMENTATION.md)

For deployment instructions, see [DEPLOYMENT.md](./DEPLOYMENT.md)
