#!/bin/bash
set -e

echo "🗑️  Removing problematic API handler..."
rm -rf api/

echo "🗑️  Removing API tsconfig..."
rm -f tsconfig.api.json

echo "✅ Cleaned up API files"
