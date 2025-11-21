#!/bin/bash
set -e

echo "📝 Committing vercel.json fix..."
git add vercel.json
git commit -m "fix: use minimal vercel.json config" || echo "No changes"

echo "⬆️ Pushing..."
git push origin main

echo ""
echo "✅ Pushed! Vercel config simplified:"
echo "   - Removed version: 2 (not needed)"
echo "   - Removed framework: null"
echo "   - Using simple rewrites instead of routes"
echo ""
echo "Check Vercel dashboard for new deployment."
