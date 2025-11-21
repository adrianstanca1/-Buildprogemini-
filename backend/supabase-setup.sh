#!/bin/bash

# Supabase Database Setup Script
# This script tests connection, runs migrations, and seeds data

set -e

echo "======================================"
echo "Supabase Database Setup"
echo "======================================"
echo ""

cd "$(dirname "$0")"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    echo "✅ Dependencies installed"
    echo ""
fi

# Test database connection
echo "🔌 Testing Supabase connection..."
node -e "
const pg = require('pg');
const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://postgres:%20Cumparavinde1%5D@db.zpbuvuxpfemldsknerew.supabase.co:5432/postgres',
  ssl: { rejectUnauthorized: false }
});
pool.query('SELECT NOW() as time, version() as version')
  .then(res => {
    console.log('✅ Connected to Supabase PostgreSQL');
    console.log('📅 Server time:', res.rows[0].time);
    console.log('🗄️  Version:', res.rows[0].version.split(' ')[0], res.rows[0].version.split(' ')[1]);
    return pool.end();
  })
  .catch(err => {
    console.error('❌ Connection failed:', err.message);
    process.exit(1);
  });
"

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Database connection failed!"
    echo "Please check your DATABASE_URL in .env file"
    exit 1
fi

echo ""

# Run migrations
echo "🔧 Running database migrations..."
npm run migrate

if [ $? -eq 0 ]; then
    echo "✅ Migrations completed"
else
    echo "⚠️  Migration failed"
    exit 1
fi

echo ""

# Run seed data
echo "🌱 Seeding database..."
npm run seed

if [ $? -eq 0 ]; then
    echo "✅ Database seeded"
else
    echo "⚠️  Seeding failed"
    exit 1
fi

echo ""
echo "======================================"
echo "✅ Supabase Setup Complete!"
echo "======================================"
echo ""
echo "Database: Supabase PostgreSQL"
echo "Host: db.zpbuvuxpfemldsknerew.supabase.co"
echo "Connection: ✅ Active"
echo ""
echo "Next steps:"
echo "  1. npm run dev    - Start backend server"
echo "  2. npm test       - Run tests"
echo "  3. make check-api - Test API endpoints"
echo ""
