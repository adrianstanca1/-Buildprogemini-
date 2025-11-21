#!/bin/bash
set -e

echo "🔨 Rebuilding..."
npm run build
cd backend && npm run build && cd ..

echo "📝 Committing..."
git add -A
git commit -m "fix: update vercel serverless config and api handler"

echo "⬆️  Pushing..."
git push origin main

echo "✅ Deployed! Vercel will rebuild with clean config."
