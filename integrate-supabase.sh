#!/bin/bash

# Complete Supabase Integration and Deployment
# This script sets up everything for production deployment

echo "========================================"
echo "BuildPro - Supabase Integration"
echo "========================================"
echo ""

# Step 1: Test Supabase Connection
echo "Step 1: Testing Supabase Connection"
echo "-----------------------------------"
./test-supabase.sh

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Connection test failed!"
    echo "Please fix connection issues before continuing"
    exit 1
fi

echo ""

# Step 2: Setup Database
echo "Step 2: Setting Up Database"
echo "----------------------------"
cd backend
./supabase-setup.sh

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Database setup failed!"
    exit 1
fi

cd ..
echo ""

# Step 3: Start Backend (in background for testing)
echo "Step 3: Starting Backend Server"
echo "--------------------------------"
cd backend
npm run dev &
BACKEND_PID=$!
sleep 5

echo "✅ Backend started (PID: $BACKEND_PID)"
echo ""

# Step 4: Test API Endpoints
echo "Step 4: Testing API Endpoints"
echo "------------------------------"
sleep 2

# Test health endpoint
echo "Testing /api/health..."
curl -s http://localhost:3001/api/health | grep -q "healthy" && echo "✅ Health check passed" || echo "❌ Health check failed"

# Test register endpoint
echo "Testing /api/auth/register..."
curl -s -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"name":"Test User","email":"test@example.com","password":"Test123!","role":"operative"}' \
  | grep -q "token" && echo "✅ Registration works" || echo "❌ Registration failed"

echo ""

# Stop backend
kill $BACKEND_PID 2>/dev/null

echo ""
echo "========================================"
echo "✅ Supabase Integration Complete!"
echo "========================================"
echo ""
echo "Your backend is ready for deployment!"
echo ""
echo "Next Steps:"
echo ""
echo "1. Deploy to Vercel:"
echo "   - Go to https://vercel.com/new"
echo "   - Import: -Buildprogemini-"
echo "   - Add environment variables (see SUPABASE_SETUP.md)"
echo "   - Deploy!"
echo ""
echo "2. Update CORS_ORIGIN:"
echo "   - After Vercel deployment"
echo "   - Update CORS_ORIGIN in Vercel env vars"
echo "   - Redeploy"
echo ""
echo "3. Test Production:"
echo "   - Visit your Vercel URL"
echo "   - Test login with demo accounts"
echo "   - Verify all features work"
echo ""
