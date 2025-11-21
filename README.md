<div align="center">
<img width="1200" height="475" alt="GHBanner" src="https://github.com/user-attachments/assets/0aa67016-6eaf-458a-adb2-6e31a0763ed6" />
</div>

# 🏗️ BuildPro - Complete Construction Management Platform

A comprehensive full-stack construction management platform with AI-powered features, built with React, TypeScript, Node.js, Express, and PostgreSQL.

[![TypeScript](https://img.shields.io/badge/TypeScript-5.8-blue)](https://www.typescriptlang.org/)
[![React](https://img.shields.io/badge/React-19-blue)](https://reactjs.org/)
[![Node.js](https://img.shields.io/badge/Node.js-18+-green)](https://nodejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-blue)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 📋 Overview

BuildPro is a production-ready construction management platform featuring:

- **🎯 Frontend**: 30+ views for comprehensive project management
- **⚡ Backend**: RESTful API with PostgreSQL database
- **🤖 AI Integration**: Google Gemini for chat, image generation, and analysis
- **🗺️ Interactive Maps**: Real-time project location tracking with Leaflet
- **👥 Team Management**: Complete workforce and resource management
- **📊 Analytics**: Real-time dashboards and reporting
- **🔒 Security**: JWT authentication with role-based access control

## 🚀 Quick Start

### Frontend Setup

```bash
# Install dependencies
npm install

# Set up environment
# Create .env.local and add your Gemini API key:
# API_KEY=your_gemini_api_key

# Run development server
npm run dev
```

Frontend runs on: **<http://localhost:5173>**

### Backend Setup

```bash
# Navigate to backend
cd backend

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env with your settings

# Start PostgreSQL (with Docker)
docker-compose up -d

# Run migrations
npm run migrate

# Seed database (optional)
npm run seed

# Start development server
npm run dev
```

Backend API runs on: **<http://localhost:3001>**

## 📁 Project Structure

```
BuildPro/
├── frontend/                 # React TypeScript frontend
│   ├── components/          # UI components
│   ├── contexts/           # React contexts
│   ├── services/           # API services
│   ├── utils/              # Utilities
│   └── views/              # 30+ page views
│
└── backend/                 # Node.js Express backend
    ├── src/
    │   ├── config/         # Database, logger, migrations
    │   ├── controllers/    # Business logic
    │   ├── middleware/     # Auth, validation
    │   ├── models/         # Data models
    │   └── routes/         # API routes
    └── logs/               # Application logs
```

## ✨ Key Features

### Frontend

- ✅ 30+ comprehensive views
- ✅ AI chat assistant powered by Gemini
- ✅ Real-time project tracking
- ✅ Interactive maps with zone annotations
- ✅ Team collaboration tools
- ✅ Document management
- ✅ Task management with Kanban
- ✅ Financial tracking
- ✅ Safety compliance monitoring
- ✅ Equipment & inventory management
- ✅ AI image generation
- ✅ Video generation (Veo 3.1)
- ✅ Voice transcription

### Backend

- ✅ RESTful API (18 endpoints)
- ✅ JWT authentication
- ✅ Role-based access control
- ✅ PostgreSQL database
- ✅ Database migrations & seeding
- ✅ Input validation
- ✅ Error handling
- ✅ Request logging
- ✅ Rate limiting
- ✅ Security headers (Helmet)
- ✅ CORS protection
- ✅ Docker support

## 🗄️ Database

### Tables

- **users** - Authentication & profiles
- **projects** - Project data
- **tasks** - Task management
- **team_members** - Team profiles
- **documents** - Document metadata
- **clients** - Client information
- **inventory** - Inventory tracking

## 🔑 Default Credentials

After seeding the database:

- **Email**: <john@buildpro.com>
- **Password**: password123
- **Role**: super_admin

## 🛠️ Technology Stack

### Frontend

- React 19
- TypeScript
- Vite
- Google Gemini API
- Leaflet Maps
- Lucide React Icons

### Backend

- Node.js
- Express
- TypeScript
- PostgreSQL
- JWT Authentication
- Winston Logging
- Docker

## 📚 Documentation

### Backend Documentation

- [**Complete Setup Guide**](backend/README.md)
- [**Quick Start**](backend/QUICKSTART.md)
- [**API Documentation**](backend/API_DOCUMENTATION.md)
- [**Deployment Guide**](backend/DEPLOYMENT.md)
- [**Implementation Summary**](backend/IMPLEMENTATION_SUMMARY.md)

### Project Documentation

- [**Project Overview**](PROJECT_OVERVIEW.md)
- [**Build Complete Summary**](backend/BUILD_COMPLETE.md)

## 🌐 API Endpoints

Base URL: `http://localhost:3001/api/v1`

### Authentication

- `POST /auth/register` - Register user
- `POST /auth/login` - Login
- `GET /auth/profile` - Get profile
- `PUT /auth/profile` - Update profile

### Projects

- `GET /projects` - List all projects
- `POST /projects` - Create project
- `PUT /projects/:id` - Update project
- `DELETE /projects/:id` - Delete project

### Tasks

- `GET /tasks` - List tasks (filterable)
- `POST /tasks` - Create task
- `PUT /tasks/:id` - Update task
- `DELETE /tasks/:id` - Delete task

### Team

- `GET /team` - List team members
- `POST /team` - Add member
- `PUT /team/:id` - Update member
- `DELETE /team/:id` - Remove member

## 👥 User Roles

- **super_admin** - Full system access
- **company_admin** - Company management
- **supervisor** - Project oversight
- **operative** - Task execution

## 🚀 Deployment

### Frontend - Vercel (Recommended)

**Quick Deploy:**

```bash
# Option 1: One-command deployment
./build-and-deploy.sh

# Option 2: Vercel CLI
npm install -g vercel
vercel --prod

# Option 3: GitHub Integration (easiest)
# Push to GitHub and import at vercel.com/new
```

**Detailed Guide**: See [VERCEL_DEPLOYMENT.md](VERCEL_DEPLOYMENT.md)

**Other Options:**

- Netlify
- GitHub Pages
- AWS S3 + CloudFront

### Backend - Node.js Hosting

- Railway.app (Recommended)
- Render.com
- Heroku
- AWS EC2
- Docker

See [Backend Deployment Guide](backend/DEPLOYMENT.md) for detailed instructions.

## 🔒 Security Features

- JWT-based authentication
- Password hashing (bcrypt)
- Role-based access control
- Rate limiting (100 req/15min)
- Helmet security headers
- CORS protection
- Input validation
- SQL injection prevention

## 📈 Development Scripts

### Frontend

```bash
npm run dev      # Development server
npm run build    # Production build
npm run preview  # Preview production build
```

### Backend

```bash
npm run dev      # Development with hot reload
npm run build    # Build TypeScript
npm start        # Run production
npm run migrate  # Run migrations
npm run seed     # Seed database
```

## 🧪 Testing

Backend includes comprehensive testing setup with Jest.

```bash
cd backend
npm test
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

- Check the [documentation](backend/README.md)
- Review [API docs](backend/API_DOCUMENTATION.md)
- See [Quick Start Guide](backend/QUICKSTART.md)
- Read [Project Overview](PROJECT_OVERVIEW.md)

## 🎯 Roadmap

- [ ] Mobile app (React Native)
- [ ] Real-time updates (WebSocket)
- [ ] File upload system
- [ ] Advanced analytics
- [ ] Third-party integrations
- [ ] Multi-tenancy support

## ✅ Status

**Production Ready** ✨

- ✅ Complete frontend with 30+ views
- ✅ Full-featured backend API
- ✅ PostgreSQL database with migrations
- ✅ Authentication & authorization
- ✅ Comprehensive documentation
- ✅ Docker support
- ✅ Deployment guides

## 👏 Acknowledgments

- Google Gemini API for AI features
- Leaflet for interactive maps
- The open-source community

---

**View in AI Studio**: <https://ai.studio/apps/drive/1ZMR1kV7w3BZvvNVQFV6OxIHnNPSN3EWc>

**Built with ❤️ for construction management excellence**
