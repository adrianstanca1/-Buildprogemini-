#!/bin/bash

# BuildPro Backend Status Checker
# Verifies all backend services and dependencies are running correctly

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

echo "======================================"
echo "BuildPro Backend Status Check"
echo "======================================"
echo ""

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v)
    print_status "Node.js $NODE_VERSION installed"
else
    print_error "Node.js not installed"
    exit 1
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm -v)
    print_status "npm $NPM_VERSION installed"
else
    print_error "npm not installed"
    exit 1
fi

# Check Docker
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker -v | cut -d' ' -f3 | cut -d',' -f1)
    print_status "Docker $DOCKER_VERSION installed"
else
    print_error "Docker not installed"
    exit 1
fi

# Check if in backend directory
if [ ! -f "package.json" ]; then
    print_error "Not in backend directory!"
    echo "Run this script from: /workspaces/-Buildprogemini-/backend"
    exit 1
fi

# Check node_modules
if [ -d "node_modules" ]; then
    print_status "Dependencies installed"
else
    print_warning "Dependencies not installed. Run: npm install"
fi

# Check .env file
if [ -f ".env" ]; then
    print_status ".env file exists"
else
    print_warning ".env file missing. Run: cp .env.example .env"
fi

# Check PostgreSQL container
if docker ps | grep -q buildpro-postgres; then
    print_status "PostgreSQL container running"
    
    # Try to connect to database
    if docker exec buildpro-postgres pg_isready -U postgres > /dev/null 2>&1; then
        print_status "PostgreSQL accepting connections"
    else
        print_warning "PostgreSQL not ready yet"
    fi
else
    print_warning "PostgreSQL container not running. Start with: docker-compose up -d"
fi

# Check if backend server is running
if curl -s http://localhost:3001/api/health > /dev/null 2>&1; then
    print_status "Backend server is running on http://localhost:3001"
    
    # Get health status
    HEALTH=$(curl -s http://localhost:3001/api/health)
    if echo "$HEALTH" | grep -q "ok"; then
        print_status "API health check passed"
    fi
else
    print_warning "Backend server not running. Start with: npm run dev"
fi

# Check if TypeScript is built
if [ -d "dist" ]; then
    print_status "TypeScript build exists"
else
    print_info "No build found. Run: npm run build"
fi

# Check logs directory
if [ -d "logs" ]; then
    LOG_COUNT=$(ls -1 logs/*.log 2>/dev/null | wc -l)
    if [ $LOG_COUNT -gt 0 ]; then
        print_info "$LOG_COUNT log file(s) in logs/"
    fi
fi

# Summary
echo ""
echo "======================================"
echo "Status Summary"
echo "======================================"
echo ""
echo "Core Dependencies:"
echo "  - Node.js: ✓"
echo "  - npm: ✓"
echo "  - Docker: ✓"
echo ""
echo "Backend Components:"

if [ -d "node_modules" ]; then
    echo "  - Dependencies: ✓"
else
    echo "  - Dependencies: ✗ (run: npm install)"
fi

if [ -f ".env" ]; then
    echo "  - Configuration: ✓"
else
    echo "  - Configuration: ✗ (run: cp .env.example .env)"
fi

if docker ps | grep -q buildpro-postgres; then
    echo "  - PostgreSQL: ✓ Running"
else
    echo "  - PostgreSQL: ✗ Not running (run: docker-compose up -d)"
fi

if curl -s http://localhost:3001/api/health > /dev/null 2>&1; then
    echo "  - API Server: ✓ Running on :3001"
else
    echo "  - API Server: ✗ Not running (run: npm run dev)"
fi

echo ""
echo "Next Steps:"
if [ ! -d "node_modules" ]; then
    echo "  1. Install dependencies: npm install"
fi
if [ ! -f ".env" ]; then
    echo "  2. Create .env file: cp .env.example .env"
fi
if ! docker ps | grep -q buildpro-postgres; then
    echo "  3. Start database: docker-compose up -d"
fi
if ! curl -s http://localhost:3001/api/health > /dev/null 2>&1; then
    echo "  4. Start backend: npm run dev"
fi

echo ""
