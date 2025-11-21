# BuildPro Backend - Deployment Guide

## 🚀 Deployment Options

### Option 1: Deploy to Railway.app

Railway provides easy PostgreSQL and Node.js deployment.

#### Steps

1. **Install Railway CLI:**

```bash
npm install -g @railway/cli
```

2. **Login to Railway:**

```bash
railway login
```

3. **Initialize Project:**

```bash
cd backend
railway init
```

4. **Add PostgreSQL:**

```bash
railway add postgresql
```

5. **Set Environment Variables:**

```bash
railway variables set NODE_ENV=production
railway variables set JWT_SECRET=your_production_jwt_secret
railway variables set PORT=3001
```

6. **Deploy:**

```bash
railway up
```

Railway will automatically:

- Detect package.json
- Run npm install
- Set database connection variables
- Deploy your application

---

### Option 2: Deploy to Render.com

Render offers free PostgreSQL and web service hosting.

#### Steps

1. **Create Render Account** at <https://render.com>

2. **Create PostgreSQL Database:**
   - Dashboard → New → PostgreSQL
   - Note the connection details

3. **Create Web Service:**
   - Dashboard → New → Web Service
   - Connect your GitHub repository
   - Settings:
     - **Build Command:** `cd backend && npm install && npm run build`
     - **Start Command:** `cd backend && npm start`
     - **Environment:** Node

4. **Add Environment Variables:**

```
NODE_ENV=production
PORT=3001
DB_HOST=[from Render PostgreSQL]
DB_PORT=5432
DB_NAME=[from Render PostgreSQL]
DB_USER=[from Render PostgreSQL]
DB_PASSWORD=[from Render PostgreSQL]
JWT_SECRET=[generate secure secret]
JWT_EXPIRES_IN=7d
CORS_ORIGIN=[your frontend URL]
```

5. **Deploy:**
   - Render auto-deploys on git push

6. **Run Migrations:**
   - Use Render Shell or connect via CLI:

```bash
npm run migrate
npm run seed
```

---

### Option 3: Deploy to Heroku

#### Steps

1. **Install Heroku CLI:**

```bash
npm install -g heroku
```

2. **Login:**

```bash
heroku login
```

3. **Create App:**

```bash
cd backend
heroku create buildpro-api
```

4. **Add PostgreSQL:**

```bash
heroku addons:create heroku-postgresql:mini
```

5. **Set Environment Variables:**

```bash
heroku config:set NODE_ENV=production
heroku config:set JWT_SECRET=your_production_jwt_secret
heroku config:set CORS_ORIGIN=https://your-frontend-url.com
```

6. **Add Procfile:**

```bash
echo "web: npm start" > Procfile
```

7. **Deploy:**

```bash
git add .
git commit -m "Deploy to Heroku"
git push heroku main
```

8. **Run Migrations:**

```bash
heroku run npm run migrate
heroku run npm run seed
```

---

### Option 4: Deploy to AWS EC2

#### Prerequisites

- AWS account
- EC2 instance (t2.micro for free tier)
- Security group with ports 22, 80, 443, 3001 open

#### Steps

1. **SSH into EC2:**

```bash
ssh -i your-key.pem ubuntu@your-ec2-ip
```

2. **Install Node.js:**

```bash
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
```

3. **Install PostgreSQL:**

```bash
sudo apt-get update
sudo apt-get install postgresql postgresql-contrib
sudo -u postgres createdb buildpro
```

4. **Clone Repository:**

```bash
git clone https://github.com/your-repo/buildpro.git
cd buildpro/backend
```

5. **Install Dependencies:**

```bash
npm install
```

6. **Create .env file:**

```bash
cat > .env << EOF
NODE_ENV=production
PORT=3001
DB_HOST=localhost
DB_PORT=5432
DB_NAME=buildpro
DB_USER=postgres
DB_PASSWORD=your_password
JWT_SECRET=your_production_jwt_secret
CORS_ORIGIN=https://your-frontend-url.com
EOF
```

7. **Run Migrations:**

```bash
npm run migrate
npm run seed
```

8. **Install PM2:**

```bash
sudo npm install -g pm2
```

9. **Build and Start:**

```bash
npm run build
pm2 start dist/server.js --name buildpro-api
pm2 startup
pm2 save
```

10. **Setup Nginx (Optional):**

```bash
sudo apt-get install nginx
```

Create Nginx config:

```nginx
server {
    listen 80;
    server_name your-domain.com;

    location / {
        proxy_pass http://localhost:3001;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

11. **SSL with Let's Encrypt:**

```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

---

### Option 5: Deploy with Docker

#### Dockerfile

```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .
RUN npm run build

EXPOSE 3001

CMD ["npm", "start"]
```

#### docker-compose.yml (Production)

```yaml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "3001:3001"
    environment:
      - NODE_ENV=production
      - DB_HOST=postgres
      - DB_PORT=5432
      - DB_NAME=buildpro
      - DB_USER=postgres
      - DB_PASSWORD=${DB_PASSWORD}
      - JWT_SECRET=${JWT_SECRET}
    depends_on:
      - postgres
    restart: unless-stopped

  postgres:
    image: postgres:16-alpine
    environment:
      - POSTGRES_DB=buildpro
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=${DB_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  postgres_data:
```

#### Deploy

```bash
docker-compose up -d
docker-compose exec api npm run migrate
docker-compose exec api npm run seed
```

---

## 🔐 Security Checklist

Before deploying to production:

- [ ] Change JWT_SECRET to a strong random value
- [ ] Set NODE_ENV=production
- [ ] Enable HTTPS/SSL
- [ ] Configure CORS_ORIGIN to your frontend domain
- [ ] Set strong database password
- [ ] Enable rate limiting (already configured)
- [ ] Review and update security headers (Helmet)
- [ ] Set up database backups
- [ ] Configure logging to external service (e.g., LogDNA, Papertrail)
- [ ] Set up monitoring (e.g., New Relic, DataDog)
- [ ] Configure firewall rules
- [ ] Use environment variables for all secrets
- [ ] Enable database SSL connections
- [ ] Set up automated backups
- [ ] Configure health checks
- [ ] Set up alerts for errors

---

## 📊 Monitoring

### Health Check Endpoint

Monitor your API with:

```bash
curl https://your-api-domain.com/api/v1/health
```

Expected response:

```json
{
  "status": "ok",
  "timestamp": "2025-11-21T10:00:00.000Z",
  "service": "BuildPro API"
}
```

### PM2 Monitoring (if using PM2)

```bash
pm2 monit
pm2 logs buildpro-api
```

### Database Connection Monitoring

Check logs for:

```
✅ Database connected successfully
```

---

## 🔄 CI/CD Pipeline (GitHub Actions)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup Node.js
      uses: actions/setup-node@v2
      with:
        node-version: '18'
    
    - name: Install dependencies
      run: |
        cd backend
        npm ci
    
    - name: Build
      run: |
        cd backend
        npm run build
    
    - name: Deploy to Railway
      run: |
        npm install -g @railway/cli
        railway up
      env:
        RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
```

---

## 🗄️ Database Backups

### Automated PostgreSQL Backups

1. **Create backup script** (`backup.sh`):

```bash
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
pg_dump -h localhost -U postgres buildpro > backup_$DATE.sql
# Upload to S3 or backup service
```

2. **Setup cron job:**

```bash
0 2 * * * /path/to/backup.sh
```

---

## 📈 Scaling Considerations

1. **Horizontal Scaling:**
   - Use load balancer (nginx, AWS ALB)
   - Deploy multiple API instances
   - Use session store (Redis)

2. **Database Optimization:**
   - Add indexes on frequently queried fields
   - Use connection pooling (already configured)
   - Consider read replicas for heavy read loads

3. **Caching:**
   - Implement Redis for frequently accessed data
   - Use CDN for static assets

4. **Performance Monitoring:**
   - Use APM tools (New Relic, DataDog)
   - Monitor database query performance
   - Track API response times

---

## 🆘 Troubleshooting

### Database Connection Issues

```bash
# Check PostgreSQL is running
sudo systemctl status postgresql

# Test connection
psql -h localhost -U postgres -d buildpro
```

### Port Already in Use

```bash
# Find process using port 3001
lsof -i :3001
kill -9 <PID>
```

### Migration Errors

```bash
# Drop and recreate database
dropdb buildpro
createdb buildpro
npm run migrate
```

### Check Logs

```bash
# View application logs
tail -f logs/combined.log
tail -f logs/error.log

# PM2 logs
pm2 logs buildpro-api
```

---

## 📞 Production Support

- Monitor logs regularly
- Set up error alerting
- Keep dependencies updated
- Regular security audits
- Database backup verification
- Performance monitoring
- Uptime monitoring

---

**Remember**: Always test deployment in a staging environment before production!
