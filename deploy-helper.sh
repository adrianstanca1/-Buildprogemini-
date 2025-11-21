#!/bin/bash

# BuildPro - Automated Deployment Helper
# This script helps you deploy the full-stack application step by step

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo -e "\n${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Generate JWT secret
generate_jwt_secret() {
    node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
}

# Main script
print_header "🚀 BuildPro Deployment Helper"

echo "This script will help you deploy your full-stack application."
echo "You'll need accounts on Railway (backend) and Vercel (frontend)."
echo ""

# Check prerequisites
print_header "📋 Checking Prerequisites"

if command_exists git; then
    print_success "Git installed"
else
    print_error "Git not found. Please install Git first."
    exit 1
fi

if command_exists node; then
    NODE_VERSION=$(node --version)
    print_success "Node.js installed ($NODE_VERSION)"
else
    print_error "Node.js not found. Please install Node.js 18+ first."
    exit 1
fi

if command_exists npm; then
    NPM_VERSION=$(npm --version)
    print_success "npm installed ($NPM_VERSION)"
else
    print_error "npm not found. Please install npm first."
    exit 1
fi

# Check if Railway CLI is installed
if command_exists railway; then
    print_success "Railway CLI installed"
    RAILWAY_INSTALLED=true
else
    print_warning "Railway CLI not installed"
    RAILWAY_INSTALLED=false
    echo ""
    read -p "Install Railway CLI now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g @railway/cli
        print_success "Railway CLI installed"
        RAILWAY_INSTALLED=true
    fi
fi

# Check if Vercel CLI is installed
if command_exists vercel; then
    print_success "Vercel CLI installed"
    VERCEL_INSTALLED=true
else
    print_warning "Vercel CLI not installed"
    VERCEL_INSTALLED=false
    echo ""
    read -p "Install Vercel CLI now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm install -g vercel
        print_success "Vercel CLI installed"
        VERCEL_INSTALLED=true
    fi
fi

# Deployment options
print_header "🎯 Deployment Options"

echo "What would you like to do?"
echo ""
echo "1) Deploy Backend to Railway (with database setup)"
echo "2) Deploy Frontend to Vercel"
echo "3) Deploy Full Stack (both backend and frontend)"
echo "4) Run Database Migrations"
echo "5) Generate JWT Secret"
echo "6) Test Deployment"
echo "7) View Deployment Status"
echo "8) Exit"
echo ""

read -p "Enter your choice (1-8): " choice

case $choice in
    1)
        print_header "🚂 Deploying Backend to Railway"
        
        if [ "$RAILWAY_INSTALLED" = false ]; then
            print_error "Railway CLI not installed. Please install it first."
            exit 1
        fi
        
        # Login to Railway
        print_info "Logging in to Railway..."
        railway login
        
        # Initialize project
        print_info "Linking to Railway project..."
        railway init
        
        # Add PostgreSQL
        print_info "Add PostgreSQL database in Railway dashboard:"
        echo "1. Go to https://railway.app/dashboard"
        echo "2. Open your project"
        echo "3. Click 'New' → 'Database' → 'PostgreSQL'"
        echo ""
        read -p "Press Enter after adding PostgreSQL..."
        
        # Generate JWT secret
        JWT_SECRET=$(generate_jwt_secret)
        print_success "Generated JWT Secret: $JWT_SECRET"
        
        # Set environment variables
        print_info "Setting environment variables..."
        railway variables set NODE_ENV=production
        railway variables set JWT_SECRET="$JWT_SECRET"
        
        echo ""
        read -p "Enter your Vercel frontend URL (e.g., https://buildpro.vercel.app): " VERCEL_URL
        railway variables set CORS_ORIGIN="$VERCEL_URL"
        
        # Deploy
        print_info "Deploying to Railway..."
        railway up
        
        print_success "Backend deployed to Railway!"
        print_info "Next step: Run database migrations (option 4)"
        ;;
        
    2)
        print_header "▲ Deploying Frontend to Vercel"
        
        if [ "$VERCEL_INSTALLED" = false ]; then
            print_error "Vercel CLI not installed. Please install it first."
            exit 1
        fi
        
        # Login to Vercel
        print_info "Logging in to Vercel..."
        vercel login
        
        # Get Railway URL
        echo ""
        read -p "Enter your Railway backend URL (e.g., https://buildpro.up.railway.app): " RAILWAY_URL
        
        # Deploy with environment variable
        print_info "Deploying to Vercel..."
        vercel --prod -e VITE_API_URL="${RAILWAY_URL}/api"
        
        print_success "Frontend deployed to Vercel!"
        print_info "Update CORS_ORIGIN in Railway with your Vercel URL"
        ;;
        
    3)
        print_header "🚀 Full Stack Deployment"
        
        print_info "This will deploy both backend and frontend."
        print_info "Make sure you have accounts on Railway and Vercel."
        echo ""
        read -p "Continue? (y/n) " -n 1 -r
        echo
        
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Deployment cancelled"
            exit 0
        fi
        
        # Deploy backend first
        print_header "Step 1: Deploy Backend to Railway"
        
        if [ "$RAILWAY_INSTALLED" = true ]; then
            railway login
            railway init
            
            JWT_SECRET=$(generate_jwt_secret)
            railway variables set NODE_ENV=production
            railway variables set JWT_SECRET="$JWT_SECRET"
            
            print_info "Add PostgreSQL in Railway dashboard, then press Enter..."
            read -p ""
            
            railway up
            
            RAILWAY_URL=$(railway status | grep "URL" | awk '{print $2}')
            print_success "Backend deployed: $RAILWAY_URL"
        else
            print_warning "Railway CLI not installed. Deploy manually at https://railway.app"
            read -p "Enter your Railway backend URL: " RAILWAY_URL
        fi
        
        # Deploy frontend
        print_header "Step 2: Deploy Frontend to Vercel"
        
        if [ "$VERCEL_INSTALLED" = true ]; then
            vercel login
            vercel --prod -e VITE_API_URL="${RAILWAY_URL}/api"
            
            VERCEL_URL=$(vercel inspect --prod | grep "URL" | awk '{print $2}')
            print_success "Frontend deployed: $VERCEL_URL"
            
            # Update CORS
            print_info "Updating CORS in Railway..."
            railway variables set CORS_ORIGIN="$VERCEL_URL"
        else
            print_warning "Vercel CLI not installed. Deploy manually at https://vercel.com"
        fi
        
        print_success "Full stack deployment complete!"
        ;;
        
    4)
        print_header "🗄️  Running Database Migrations"
        
        if [ "$RAILWAY_INSTALLED" = false ]; then
            print_error "Railway CLI not installed. Please install it first."
            exit 1
        fi
        
        # Link to project
        railway link
        
        # Run migrations
        print_info "Running migrations..."
        railway run npm run migrate --dir backend
        
        # Ask about seeding
        echo ""
        read -p "Seed database with demo data? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            railway run npm run seed --dir backend
            print_success "Database seeded"
        fi
        
        print_success "Database migrations complete!"
        ;;
        
    5)
        print_header "🔐 Generate JWT Secret"
        
        JWT_SECRET=$(generate_jwt_secret)
        echo ""
        print_success "Your JWT Secret:"
        echo ""
        echo "$JWT_SECRET"
        echo ""
        print_info "Copy this and add it to Railway environment variables"
        print_info "Railway Dashboard → Your Project → Variables → JWT_SECRET"
        ;;
        
    6)
        print_header "🧪 Testing Deployment"
        
        # Get URLs
        read -p "Enter your Railway backend URL: " RAILWAY_URL
        read -p "Enter your Vercel frontend URL: " VERCEL_URL
        
        # Test backend health
        print_info "Testing backend health..."
        if curl -s "${RAILWAY_URL}/api/health" | grep -q "ok"; then
            print_success "Backend is healthy"
        else
            print_error "Backend health check failed"
        fi
        
        # Test frontend
        print_info "Testing frontend..."
        if curl -s -o /dev/null -w "%{http_code}" "$VERCEL_URL" | grep -q "200"; then
            print_success "Frontend is accessible"
        else
            print_error "Frontend not accessible"
        fi
        
        # Test database
        print_info "Testing database connection..."
        REGISTER_RESPONSE=$(curl -s -X POST "${RAILWAY_URL}/api/auth/register" \
            -H "Content-Type: application/json" \
            -d '{"email":"test@test.com","password":"test123","name":"Test"}')
        
        if echo "$REGISTER_RESPONSE" | grep -q "token\|email"; then
            print_success "Database connection working"
        else
            print_warning "Database might not be connected"
        fi
        
        print_success "Deployment tests complete!"
        ;;
        
    7)
        print_header "📊 Deployment Status"
        
        if [ "$RAILWAY_INSTALLED" = true ]; then
            print_info "Railway Status:"
            railway status
        fi
        
        echo ""
        
        if [ "$VERCEL_INSTALLED" = true ]; then
            print_info "Vercel Status:"
            vercel ls
        fi
        ;;
        
    8)
        print_info "Exiting..."
        exit 0
        ;;
        
    *)
        print_error "Invalid choice"
        exit 1
        ;;
esac

print_header "✅ Done!"
echo ""
print_info "For detailed instructions, see:"
echo "  - DEPLOY_NOW.md (quick reference)"
echo "  - FULLSTACK_DEPLOYMENT.md (complete guide)"
echo ""
print_info "Useful commands:"
echo "  - railway logs (view backend logs)"
echo "  - vercel logs (view frontend logs)"
echo "  - railway open (open Railway dashboard)"
echo "  - vercel inspect (view deployment details)"
echo ""
