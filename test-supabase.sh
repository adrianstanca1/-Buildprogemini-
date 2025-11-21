#!/bin/bash

# Quick Supabase Connection Test
echo "Testing Supabase connection..."
echo ""

cd backend

node -e "
const pg = require('pg');
require('dotenv').config();

const pool = new pg.Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

console.log('🔌 Connecting to Supabase...');
console.log('📍 Host: db.zpbuvuxpfemldsknerew.supabase.co');
console.log('');

pool.query('SELECT NOW() as time, current_database() as db, version() as version')
  .then(res => {
    console.log('✅ CONNECTION SUCCESSFUL!');
    console.log('');
    console.log('Database:', res.rows[0].db);
    console.log('Time:', res.rows[0].time);
    console.log('Version:', res.rows[0].version.split(' ')[1]);
    console.log('');
    console.log('✅ Supabase is ready!');
    console.log('');
    console.log('Next: Run ./backend/supabase-setup.sh to migrate and seed');
    return pool.end();
  })
  .catch(err => {
    console.error('❌ CONNECTION FAILED!');
    console.error('');
    console.error('Error:', err.message);
    console.error('');
    console.error('Check:');
    console.error('1. DATABASE_URL in backend/.env');
    console.error('2. Supabase project is active');
    console.error('3. IP/connection limits');
    process.exit(1);
  });
"
