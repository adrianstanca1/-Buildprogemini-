# BuildPro Backend - Quick Start Guide

## Prerequisites

- Docker and Docker Compose installed
- Node.js 18+ installed

## Quick Setup

### 1. Start PostgreSQL Database

```bash
docker-compose up -d
```

This will start:

- PostgreSQL on port 5432
- pgAdmin on <http://localhost:5050> (<admin@buildpro.com> / admin)

### 2. Install Dependencies

```bash
npm install
```

### 3. Set Up Environment

```bash
5. Set up environment variables:
   ```bash
   cp .env.example .env
   ```

Edit `.env` if needed (default settings work with docker-compose):

```env
DB_HOST=localhost
DB_PORT=5432
DB_NAME=buildpro
DB_USER=postgres
DB_PASSWORD=postgres
```

### 4. Run Migrations

```bash
npm run migrate
```

### 5. Seed Database (Optional)

```bash
npm run seed
```

### 6. Start Development Server

```bash
npm run dev
```

The API will be available at <http://localhost:3001>

## Test the API

### Health Check

```bash
curl http://localhost:3001/api/v1/health
```

### Login with Seeded User

```bash
curl -X POST http://localhost:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@buildpro.com","password":"password123"}'
```

## Stop Services

```bash
docker-compose down
```

## Clean Database

```bash
docker-compose down -v
```

## Access pgAdmin

1. Open <http://localhost:5050>
2. Login with <admin@buildpro.com> / admin
3. Add server:
   - Host: postgres
   - Port: 5432
   - Database: buildpro
   - Username: postgres
   - Password: postgres
