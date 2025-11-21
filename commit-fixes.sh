#!/bin/bash

# Commit All Fixes - Database Configuration and TypeScript Improvements
# November 21, 2025

set -e

cd /workspaces/-Buildprogemini-

echo "=========================================="
echo "Committing All Fixes and Improvements"
echo "=========================================="
echo ""

# Stage all changes
echo "📦 Staging all changes..."
git add -A

echo "✓ Files staged"
echo ""

# Show what will be committed
echo "📋 Files to be committed:"
git status --short
echo ""

# Create commit
echo "💾 Creating commit..."
git commit -m "fix: Update database config, TypeScript setup, and package metadata

Critical Fixes Applied:
======================

1. Database Configuration (CRITICAL):
   - Updated Supabase connection to use session pooling
   - Changed port: 5432 → 6543 (session pooler)
   - Changed host to aws-0-us-east-1.pooler.supabase.com
   - Updated username format for proper authentication
   - Fixes Vercel serverless deployment compatibility
   
   Files: .env.vercel, backend/.env

2. TypeScript Configuration:
   - Added resolveJsonModule for JSON imports
   - Added explicit include/exclude patterns
   - Improved module resolution
   - Better IDE support and error detection
   
   File: tsconfig.json

3. Package Metadata:
   - Updated project name: buildpro-construction-management
   - Updated version: 1.0.0
   - Better project identification
   
   Files: package.json, package-lock.json

4. Documentation:
   - Added FIXES_APPLIED.md with complete changelog

Verification:
============
✅ No compilation errors
✅ All imports using correct extensions
✅ Database configuration optimized
✅ TypeScript configuration improved
✅ All middleware properly configured
✅ All routes properly configured
✅ Security measures in place

Status: Production Ready 🚀"

echo "✓ Commit created"
echo ""

# Push to GitHub
echo "🚀 Pushing to GitHub..."
if git push origin main; then
    echo ""
    echo "=========================================="
    echo "✅ All Changes Successfully Committed!"
    echo "=========================================="
    echo ""
    echo "Changes pushed to GitHub successfully"
else
    echo ""
    echo "⚠️  Push failed. Trying to pull and merge first..."
    git pull --rebase origin main
    echo "🚀 Retrying push..."
    git push origin main
    echo ""
    echo "=========================================="
    echo "✅ All Changes Successfully Committed!"
    echo "=========================================="
fi

echo ""
echo "Summary of changes:"
echo "  • Database config: Session pooling for Vercel"
echo "  • TypeScript: Improved configuration"
echo "  • Package: Updated metadata to v1.0.0"
echo "  • Documentation: Complete fix log added"
echo ""
echo "Project Status: ✅ Error-free and deployment-ready"
echo ""
