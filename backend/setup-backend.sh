#!/bin/bash

# BuildPro Backend Setup Script
# This script sets up and verifies the backend environment

set -e

echo "======================================"
echo "BuildPro Backend Setup"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Navigate to backend directory
cd "$(dirname "$0")"

# Step 1: Check for Node.js
print_info "Checking Node.js installation..."
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js 18+ first."
    exit 1
fi
NODE_VERSION=$(node -v)
print_status "Node.js $NODE_VERSION detected"

# Step 2: Check for npm
print_info "Checking npm installation..."
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi
NPM_VERSION=$(npm -v)
print_status "npm $NPM_VERSION detected"

# Step 3: Install dependencies
print_info "Installing dependencies..."
if [ ! -d "node_modules" ]; then
    npm install
    print_status "Dependencies installed"
else
    print_status "Dependencies already installed"
fi

# Step 4: Check for .env file
print_info "Checking environment configuration..."
if [ ! -f ".env" ]; then
    print_info "Creating .env file from template..."
    cp .env.example .env
    print_status ".env file created"
else
    print_status ".env file exists"
fi

# Step 5: Check for Docker
print_info "Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker to run PostgreSQL."
    print_info "You can install Docker from: https://docs.docker.com/get-docker/"
    exit 1
fi
print_status "Docker detected"

# Step 6: Check if PostgreSQL container is running
print_info "Checking PostgreSQL container..."
if docker ps | grep -q buildpro-postgres; then
    print_status "PostgreSQL container is running"
else
    print_info "Starting PostgreSQL container..."
    if [ -f "docker-compose.yml" ]; then
        docker-compose up -d
        print_status "PostgreSQL container started"
        print_info "Waiting for PostgreSQL to be ready..."
        sleep 5
    else
        print_error "docker-compose.yml not found"
        exit 1
    fi
fi

# Step 7: Run migrations
print_info "Running database migrations..."
npm run migrate
print_status "Migrations completed"

# Step 8: Seed database
print_info "Seeding database with initial data..."
npm run seed
print_status "Database seeded"

# Step 9: Build TypeScript
print_info "Building TypeScript..."
npm run build
print_status "Build completed"

echo ""
echo "======================================"
echo -e "${GREEN}Backend Setup Complete!${NC}"
echo "======================================"
echo ""
echo "Next steps:"
echo "  1. Start the development server: npm run dev"
echo "  2. The API will be available at: http://localhost:3001"
echo "  3. Test endpoints using the API documentation in API_DOCUMENTATION.md"
echo ""
echo "Useful commands:"
echo "  - npm run dev      : Start development server with hot reload"
echo "  - npm run build    : Build for production"
echo "  - npm start        : Start production server"
echo "  - npm run migrate  : Run database migrations"
echo "  - npm run seed     : Seed database with test data"
echo ""
