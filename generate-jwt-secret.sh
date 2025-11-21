#!/bin/bash

# Generate JWT Secret for Vercel deployment
echo "🔐 Generating secure JWT secret..."
echo ""
JWT_SECRET=$(node -e "console.log(require('crypto').randomBytes(64).toString('hex'))")
echo "Your JWT Secret:"
echo "$JWT_SECRET"
echo ""
echo "Copy this value and add it to Vercel:"
echo "1. Go to vercel.com → Your Project → Settings → Environment Variables"
echo "2. Add: JWT_SECRET = $JWT_SECRET"
echo ""
