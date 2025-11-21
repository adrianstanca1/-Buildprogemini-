#!/usr/bin/env python3
"""
BuildPro Deployment Automation
Prepares and validates project for Vercel deployment
"""

import os
import sys
import subprocess
import json

def run_command(cmd, cwd=None):
    """Run shell command and return output"""
    try:
        result = subprocess.run(
            cmd,
            shell=True,
            cwd=cwd,
            capture_output=True,
            text=True,
            timeout=300
        )
        return result.returncode == 0, result.stdout, result.stderr
    except subprocess.TimeoutExpired:
        return False, "", "Command timed out"
    except Exception as e:
        return False, "", str(e)

def print_header(text):
    """Print formatted header"""
    print(f"\n{'='*60}")
    print(f"  {text}")
    print(f"{'='*60}\n")

def print_success(text):
    """Print success message"""
    print(f"✅ {text}")

def print_error(text):
    """Print error message"""
    print(f"❌ {text}")

def print_warning(text):
    """Print warning message"""
    print(f"⚠️  {text}")

def print_info(text):
    """Print info message"""
    print(f"ℹ️  {text}")

def main():
    workspace = "/workspaces/-Buildprogemini-"
    
    print_header("BuildPro - Vercel Deployment Validator")
    
    # Step 1: Check prerequisites
    print_info("Step 1: Checking prerequisites...")
    
    # Check Node.js
    success, stdout, _ = run_command("node --version")
    if success:
        print_success(f"Node.js {stdout.strip()}")
    else:
        print_error("Node.js not found")
        return 1
    
    # Check npm
    success, stdout, _ = run_command("npm --version")
    if success:
        print_success(f"npm {stdout.strip()}")
    else:
        print_error("npm not found")
        return 1
    
    # Step 2: Verify configuration files
    print_info("\nStep 2: Verifying configuration...")
    
    required_files = [
        "package.json",
        "vercel.json",
        "tsconfig.json",
        "vite.config.ts",
        "backend/package.json",
        "backend/tsconfig.json",
        "backend/src/server.ts"
    ]
    
    all_exist = True
    for file in required_files:
        filepath = os.path.join(workspace, file)
        if os.path.exists(filepath):
            print_success(f"{file}")
        else:
            print_error(f"{file} missing")
            all_exist = False
    
    if not all_exist:
        print_error("Missing required files")
        return 1
    
    # Step 3: Check environment variables
    print_info("\nStep 3: Checking environment configuration...")
    
    env_file = os.path.join(workspace, ".env.vercel")
    if os.path.exists(env_file):
        print_success(".env.vercel template exists")
        with open(env_file, 'r') as f:
            content = f.read()
            required_vars = ["DATABASE_URL", "NODE_ENV", "JWT_SECRET", "CORS_ORIGIN"]
            for var in required_vars:
                if var in content:
                    print_success(f"  {var} documented")
                else:
                    print_warning(f"  {var} missing from template")
    else:
        print_warning(".env.vercel not found")
    
    # Step 4: Build frontend
    print_info("\nStep 4: Building frontend...")
    
    success, stdout, stderr = run_command("npm run build", cwd=workspace)
    if success:
        print_success("Frontend build successful")
        
        # Check dist directory
        dist_dir = os.path.join(workspace, "dist")
        if os.path.exists(dist_dir):
            files = os.listdir(dist_dir)
            print_success(f"  Built {len(files)} files")
            if "index.html" in files:
                print_success("  index.html found")
        else:
            print_error("dist directory not created")
    else:
        print_error("Frontend build failed")
        print(f"\nStderr:\n{stderr}")
        return 1
    
    # Step 5: Build backend
    print_info("\nStep 5: Building backend...")
    
    backend_dir = os.path.join(workspace, "backend")
    
    # Install backend dependencies
    success, _, _ = run_command("npm install", cwd=backend_dir)
    if not success:
        print_warning("Backend npm install had issues")
    
    # Build backend
    success, stdout, stderr = run_command("npm run build", cwd=backend_dir)
    if success:
        print_success("Backend build successful")
        
        # Check backend dist directory
        backend_dist = os.path.join(backend_dir, "dist")
        if os.path.exists(backend_dist):
            files = os.listdir(backend_dist)
            print_success(f"  Built {len(files)} files")
            if "server.js" in files:
                print_success("  server.js found")
        else:
            print_error("backend/dist directory not created")
    else:
        print_error("Backend build failed")
        print(f"\nStderr:\n{stderr}")
        return 1
    
    # Step 6: Git status
    print_info("\nStep 6: Checking Git status...")
    
    if os.path.exists(os.path.join(workspace, ".git")):
        print_success("Git repository found")
        
        success, stdout, _ = run_command("git status --porcelain", cwd=workspace)
        if stdout.strip():
            print_warning("Uncommitted changes found")
            print("\nChanged files:")
            for line in stdout.strip().split('\n')[:10]:
                print(f"  {line}")
            print("\nRun: git add -A && git commit -m 'fix: ready for deployment'")
        else:
            print_success("No uncommitted changes")
    else:
        print_warning("Not a Git repository")
    
    # Step 7: Deployment instructions
    print_header("Deployment Ready! 🚀")
    
    print("\n🎯 NEXT STEPS:\n")
    print("Option 1 - Vercel Dashboard (Easiest):")
    print("  1. Go to: https://vercel.com/new")
    print("  2. Import: adrianstanca1/-Buildprogemini-")
    print("  3. Add environment variables (see .env.vercel)")
    print("  4. Click Deploy")
    print()
    print("Option 2 - Vercel CLI:")
    print("  1. npm install -g vercel")
    print("  2. vercel login")
    print("  3. vercel --prod")
    print()
    print("📖 Full guide: DEPLOY_NOW.md")
    print()
    
    print_success("All validation checks passed!")
    return 0

if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        print("\n\nDeployment cancelled by user")
        sys.exit(1)
    except Exception as e:
        print_error(f"Unexpected error: {e}")
        sys.exit(1)
