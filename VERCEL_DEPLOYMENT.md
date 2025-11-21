# BuildPro - Vercel Deployment Guide

## Quick Deploy to Vercel

### Prerequisites

1. **Vercel Account**: Sign up at [vercel.com](https://vercel.com)
2. **Vercel CLI** (optional): `npm install -g vercel`

### Method 1: GitHub Integration (Recommended)

1. **Push to GitHub** (if not already done):

   ```bash
   git add .
   git commit -m "feat: prepare for Vercel deployment"
   git push origin main
   ```

2. **Connect to Vercel**:
   - Go to [vercel.com/new](https://vercel.com/new)
   - Import your GitHub repository: `adrianstanca1/-Buildprogemini-`
   - Configure project:
     - **Framework Preset**: Vite
     - **Root Directory**: `./`
     - **Build Command**: `npm run build`
     - **Output Directory**: `dist`
   - Click "Deploy"

3. **Automatic Deployments**:
   - Every push to `main` branch will auto-deploy to production
   - Pull requests will create preview deployments

### Method 2: Vercel CLI

1. **Install Vercel CLI**:

   ```bash
   npm install -g vercel
   ```

2. **Login to Vercel**:

   ```bash
   vercel login
   ```

3. **Deploy**:

   ```bash
   # Preview deployment
   vercel

   # Production deployment
   vercel --prod
   ```

### Method 3: Using Deployment Script

1. **Run the deployment script**:

   ```bash
   chmod +x deploy-vercel.sh
   ./deploy-vercel.sh
   ```

2. **Follow the prompts** to deploy with Vercel CLI

### Method 4: Manual Upload

1. **Build the project**:

   ```bash
   npm run build
   ```

2. **Upload to Vercel**:
   - Go to [vercel.com/new](https://vercel.com/new)
   - Click "Continue with Other"
   - Drag and drop the `dist` folder
   - Click "Deploy"

## Environment Variables

If you're using the backend API, configure these environment variables in Vercel:

1. Go to your project settings on Vercel
2. Navigate to "Environment Variables"
3. Add:

   ```
   VITE_API_URL=https://your-backend-api.com/api
   ```

## Post-Deployment

After deployment, Vercel will provide:

- **Production URL**: `https://your-project.vercel.app`
- **Preview URLs**: For each deployment
- **Analytics**: Built-in web analytics
- **Automatic HTTPS**: SSL certificates included

## Vercel Configuration

The project includes:

- `vercel.json` - Vercel configuration
- `.vercelignore` - Files to exclude from deployment

### Custom Domain (Optional)

1. Go to your project settings
2. Click "Domains"
3. Add your custom domain
4. Follow DNS configuration instructions

## Troubleshooting

### Build Fails

Check the build logs in Vercel dashboard:

- Ensure all dependencies are in `package.json`
- Verify build command: `npm run build`
- Check for TypeScript errors

### Runtime Errors

- Check browser console for errors
- Verify environment variables are set
- Ensure API endpoints are accessible

### CORS Issues

If connecting to a backend:

- Backend must allow Vercel domain in CORS settings
- Update backend `CORS_ORIGIN` to include Vercel URL

## Development Workflow

1. **Local Development**:

   ```bash
   npm run dev
   ```

2. **Test Build Locally**:

   ```bash
   npm run build
   npm run preview
   ```

3. **Deploy Preview**:

   ```bash
   vercel
   ```

4. **Deploy Production**:

   ```bash
   vercel --prod
   ```

## Monitoring

Vercel provides:

- **Real-time logs**: View deployment and runtime logs
- **Analytics**: Page views, performance metrics
- **Error tracking**: Runtime error monitoring

Access these in your Vercel dashboard.

## Backend Deployment

Note: The backend (Node.js/Express) needs separate deployment:

- **Recommended**: Railway, Render, or Heroku for Node.js backend
- **Database**: Deploy PostgreSQL separately or use managed service
- See `backend/DEPLOYMENT.md` for backend deployment guide

## Quick Commands

```bash
# Build frontend
npm run build

# Deploy preview
vercel

# Deploy production
vercel --prod

# View deployments
vercel ls

# Open in browser
vercel open
```

## Support

- **Vercel Docs**: [vercel.com/docs](https://vercel.com/docs)
- **Vite Deployment**: [vitejs.dev/guide/static-deploy](https://vitejs.dev/guide/static-deploy.html)
- **GitHub Integration**: [vercel.com/docs/git](https://vercel.com/docs/git)

---

**Ready to Deploy!** Choose your preferred method above and deploy BuildPro to Vercel. 🚀
