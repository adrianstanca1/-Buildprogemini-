#!/bin/bash
set -e

echo "🔧 Installing dependencies..."
npm install

echo "🔨 Building frontend only..."
npm run build

echo "📝 Committing simplified config..."
git add -A
git commit -m "fix: simplify vercel config - frontend only deployment"

echo "⬆️ Pushing..."
git push origin main

echo ""
echo "✅ Pushed! This deploys ONLY the frontend."
echo "   The backend will be deployed separately."
