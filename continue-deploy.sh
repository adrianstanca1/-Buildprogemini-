#!/bin/bash
# Quick verification and continuation script

echo "🔍 Verifying fixes..."
echo ""

cd /workspaces/-Buildprogemini-/backend

echo "Building backend..."
npm run build

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Backend build successful!"
    echo "✅ All TypeScript errors fixed!"
    echo ""
    echo "Proceeding with deployment..."
    cd ..
    
    # Continue with deployment
    echo ""
    echo "================================================"
    echo "  DEPLOYMENT OPTIONS"
    echo "================================================"
    echo ""
    echo "1. Vercel Dashboard (Recommended)"
    echo "   Go to: https://vercel.com/new"
    echo "   Import: adrianstanca1/-Buildprogemini-"
    echo "   Add environment variables (see .env.vercel)"
    echo "   Click Deploy"
    echo ""
    echo "2. Vercel CLI"
    echo "   npm install -g vercel"
    echo "   vercel --prod"
    echo ""
    echo "3. Commit & Push First"
    echo "   git add -A"
    echo "   git commit -m 'fix: backend TypeScript errors resolved'"
    echo "   git push origin main"
    echo ""
    
    read -p "Open Vercel Dashboard? [Y/n] " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]] || [ -z "$REPLY" ]; then
        if command -v xdg-open &> /dev/null; then
            xdg-open "https://vercel.com/new" 2>/dev/null &
        elif command -v open &> /dev/null; then
            open "https://vercel.com/new" &
        elif [ -n "$BROWSER" ]; then
            "$BROWSER" "https://vercel.com/new" &
        else
            echo "Please open: https://vercel.com/new"
        fi
    fi
else
    echo ""
    echo "❌ Build failed - checking errors..."
    exit 1
fi
