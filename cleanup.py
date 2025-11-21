#!/usr/bin/env python3
import os

# Files to remove
files_to_remove = [
    "build-and-deploy.sh",
    "commit-all.sh",
    "commit-and-deploy.sh",
    "commit-backend-fixes.sh",
    "commit-backend.sh",
    "commit-fixes.sh",
    "DEPLOY_FIXED.sh",
    "deploy-fullstack.sh",
    "deploy-helper.sh",
    "deploy-now.sh",
    "deploy-to-vercel.sh",
    "deploy-vercel.sh",
    "DEPLOY.sh",
    "do-commit.sh",
    "finalize-deployment.sh",
    "generate-jwt-secret.sh",
    "git-commit.py",
    "integrate-supabase.sh",
    "quick-deploy.sh",
    "test-supabase.sh",
    "vercel-build.sh",
    "cleanup-project.sh",
    ".cleanup-report.md",
    "DEPLOY_NOW.md",
    "DEPLOYMENT_READY.md",
    "DEPLOYMENT_STATUS.md",
    "FULLSTACK_DEPLOYMENT.md",
    "QUICK_DEPLOY_GUIDE.md",
    "QUICK_DEPLOY.md",
    "VERCEL_AUTO_DEPLOY.md",
    "VERCEL_DEPLOYMENT_COMPLETE.md",
    "VERCEL_DEPLOYMENT.md",
    "VERCEL_ENV_VARS.txt",
    "VERCEL_SUPABASE_DEPLOYMENT.md",
]

workspace = "/workspaces/-Buildprogemini-"
removed = []
not_found = []

for file in files_to_remove:
    filepath = os.path.join(workspace, file)
    if os.path.exists(filepath):
        try:
            os.remove(filepath)
            removed.append(file)
        except Exception as e:
            print(f"Error removing {file}: {e}")
    else:
        not_found.append(file)

print(f"✅ Removed {len(removed)} files:")
for f in removed:
    print(f"  - {f}")

if not_found:
    print(f"\n⚠️  {len(not_found)} files not found (already removed)")

print(f"\n🎉 Cleanup complete! Kept: deploy.sh, commit.sh, DEPLOYMENT.md, FIXES_APPLIED.md")
