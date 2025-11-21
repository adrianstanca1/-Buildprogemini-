#!/bin/bash

# BuildPro Backend Setup Verification Script

echo "🔍 BuildPro Backend Setup Verification"
echo "========================================"
echo ""

# Check Node.js
echo "1️⃣  Checking Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "   ✅ Node.js installed: $NODE_VERSION"
else
    echo "   ❌ Node.js not found. Please install Node.js 18+"
    exit 1
fi

# Check npm
echo "2️⃣  Checking npm..."
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "   ✅ npm installed: $NPM_VERSION"
else
    echo "   ❌ npm not found"
    exit 1
fi

# Check for package.json
echo "3️⃣  Checking project files..."
if [ -f "package.json" ]; then
    echo "   ✅ package.json found"
else
    echo "   ❌ package.json not found. Are you in the backend directory?"
    exit 1
fi

# Check for .env file
echo "4️⃣  Checking environment configuration..."
if [ -f ".env" ]; then
    echo "   ✅ .env file exists"
else
    echo "   ⚠️  .env file not found. Creating from .env.example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "   ✅ .env file created. Please update it with your settings."
    else
        echo "   ❌ .env.example not found"
        exit 1
    fi
fi

# Check for node_modules
echo "5️⃣  Checking dependencies..."
if [ -d "node_modules" ]; then
    echo "   ✅ Dependencies installed"
else
    echo "   ⚠️  Dependencies not installed. Running npm install..."
    npm install
    if [ $? -eq 0 ]; then
        echo "   ✅ Dependencies installed successfully"
    else
        echo "   ❌ Failed to install dependencies"
        exit 1
    fi
fi

# Check PostgreSQL
echo "6️⃣  Checking PostgreSQL..."
if command -v psql &> /dev/null; then
    PSQL_VERSION=$(psql --version)
    echo "   ✅ PostgreSQL installed: $PSQL_VERSION"
elif command -v docker &> /dev/null; then
    echo "   ⚠️  PostgreSQL not installed locally, but Docker is available"
    echo "   💡 You can run: docker-compose up -d"
else
    echo "   ⚠️  PostgreSQL not found. Please install PostgreSQL or use Docker"
fi

# Check Docker
echo "7️⃣  Checking Docker..."
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version)
    echo "   ✅ Docker installed: $DOCKER_VERSION"
    
    if command -v docker-compose &> /dev/null; then
        echo "   ✅ docker-compose available"
        echo "   💡 Run 'docker-compose up -d' to start PostgreSQL"
    fi
else
    echo "   ⚠️  Docker not found (optional)"
fi

# Check TypeScript
echo "8️⃣  Checking TypeScript..."
if [ -f "tsconfig.json" ]; then
    echo "   ✅ TypeScript configuration found"
else
    echo "   ❌ tsconfig.json not found"
    exit 1
fi

# Check project structure
echo "9️⃣  Checking project structure..."
REQUIRED_DIRS=("src/config" "src/controllers" "src/middleware" "src/models" "src/routes" "logs")
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "   ✅ $dir exists"
    else
        echo "   ❌ $dir not found"
        exit 1
    fi
done

echo ""
echo "========================================"
echo "✅ Setup verification complete!"
echo ""
echo "📝 Next steps:"
echo "   1. Update .env with your database credentials"
echo "   2. Start PostgreSQL: docker-compose up -d (or use local PostgreSQL)"
echo "   3. Run migrations: npm run migrate"
echo "   4. Seed database (optional): npm run seed"
echo "   5. Start dev server: npm run dev"
echo ""
echo "📚 Documentation:"
echo "   - README.md - Full setup guide"
echo "   - QUICKSTART.md - Quick start instructions"
echo "   - API_DOCUMENTATION.md - API reference"
echo "   - DEPLOYMENT.md - Production deployment guide"
echo ""
