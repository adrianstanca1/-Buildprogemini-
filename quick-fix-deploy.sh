#!/bin/bash
set -e

echo "🔨 Rebuilding with fixes..."
npm run build

echo "📝 Committing changes..."
git add -A
git commit -m "fix: vercel deployment - simplify config and ensure base path" || echo "No changes to commit"

echo "⬆️  Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Done! Vercel will auto-deploy from GitHub."
echo "   Check your Vercel dashboard for the new deployment."
