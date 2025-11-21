#!/bin/bash
set -e

echo "🔨 Building..."
npm run build

echo "📝 Committing all changes..."
git add -A
git commit -m "fix: simplify vercel config for frontend deployment" || echo "No new changes"

echo "⬆️ Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Deployed! Vercel will auto-deploy the frontend."
echo "   Check: https://vercel.com/dashboard"
