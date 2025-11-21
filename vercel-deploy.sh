#!/bin/bash
# Quick Deploy to Vercel - BuildPro Construction Management

set -e

echo "🚀 BuildPro - Vercel Deployment"
echo "================================"
echo ""

# Check if vercel CLI is installed
if ! command -v vercel &> /dev/null; then
    echo "📦 Installing Vercel CLI..."
    npm install -g vercel
fi

# Login to Vercel
echo "🔐 Logging into Vercel..."
vercel login

# Deploy to production
echo "🚀 Deploying to production..."
vercel --prod \
  --yes \
  --env DATABASE_URL="postgresql://postgres.zpbuvuxpfemldsknerew:%20Cumparavinde1%5D@aws-0-us-east-1.pooler.supabase.com:6543/postgres" \
  --env NODE_ENV="production" \
  --env JWT_SECRET="buildpro_jwt_secret_2025_production_key_secure_random_string" \
  --env CORS_ORIGIN="https://buildpro.vercel.app"

echo ""
echo "✅ Deployment Complete!"
echo ""
echo "Your app is now live at:"
vercel --prod --yes 2>&1 | grep -o 'https://[^ ]*' | head -1
echo ""
