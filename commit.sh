#!/bin/bash

# Commit All Changes - BuildPro
# Single commit script for all changes

set -e

cd /workspaces/-Buildprogemini-

echo "💾 Committing BuildPro Changes"
echo "=============================="
echo ""

# Stage all changes
git add -A

# Check if there are changes
if git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "✅ No changes to commit"
    exit 0
fi

# Show what will be committed
echo "📋 Changes to commit:"
git status --short
echo ""

# Commit with message
read -p "Enter commit message (or press Enter for default): " msg

if [ -z "$msg" ]; then
    msg="chore: Update BuildPro project files"
fi

git commit -m "$msg"
echo "✅ Committed: $msg"
echo ""

# Push
read -p "Push to GitHub? (y/n): " push

if [ "$push" = "y" ] || [ "$push" = "Y" ]; then
    git push origin main
    echo "✅ Pushed to GitHub"
else
    echo "⏸️  Changes committed locally (not pushed)"
fi

echo ""
echo "✅ Done!"
