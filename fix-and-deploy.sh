#!/bin/bash
set -e

echo "🔨 Rebuilding with fixed HTML..."
npm run build

echo "📝 Committing fix..."
git add -A
git commit -m "fix: remove import map conflicting with Vite bundled code" || echo "No changes"

echo "⬆️  Pushing to GitHub..."
git push origin main

echo ""
echo "✅ Fix deployed! Vercel will rebuild automatically."
echo "   The white screen should be resolved now."
