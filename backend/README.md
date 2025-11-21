# BuildPro Backend API

A comprehensive RESTful API for the BuildPro Construction Management Platform built with Node.js, Express, TypeScript, and PostgreSQL.

## 🚀 Features

- **Authentication & Authorization**: JWT-based authentication with role-based access control
- **Project Management**: CRUD operations for construction projects
- **Task Management**: Create, assign, and track project tasks
- **Team Management**: Manage team members and their assignments
- **Security**: Helmet, CORS, rate limiting, input validation
- **Database**: PostgreSQL with connection pooling
- **Logging**: Winston logger with file and console outputs
- **Error Handling**: Centralized error handling middleware
- **Validation**: Express-validator for request validation

## 📋 Prerequisites

- Node.js >= 18.x
- PostgreSQL >= 14.x
- npm or yarn

## 🛠️ Installation

**For detailed integration instructions, see [INTEGRATION_GUIDE.md](./INTEGRATION_GUIDE.md)**

### Quick Start

Use the automated setup script:

```bash
chmod +x setup-backend.sh
./setup-backend.sh
```

### Manual Setup

1. Navigate to the backend directory:

   ```bash
   cd backend
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Create a `.env` file based on `.env.example`:

   ```bash
   cp .env.example .env
   ```

4. Configure your environment variables in `.env`:

```env
PORT=3001
NODE_ENV=development

DB_HOST=localhost
DB_PORT=5432
DB_NAME=buildpro
DB_USER=postgres
DB_PASSWORD=your_password

JWT_SECRET=your_jwt_secret_key_change_in_production
JWT_EXPIRES_IN=7d

CORS_ORIGIN=http://localhost:5173
```

## 🗄️ Database Setup

1. Create a PostgreSQL database:

   ```bash
   createdb buildpro
   ```

2. Run migrations to create tables:

   ```bash
   npm run migrate
   ```

3. (Optional) Seed the database with sample data:

   ```bash
   npm run seed
   ```

## 🏃 Running the Server

### Development mode (with hot reload)

```bash
npm run dev
```

### Production mode

```bash
npm run build
npm start
```

The server will start on `http://localhost:3001` (or the PORT specified in .env)

## 📚 API Endpoints

### Authentication

- `POST /api/v1/auth/register` - Register a new user
- `POST /api/v1/auth/login` - Login user
- `GET /api/v1/auth/profile` - Get current user profile (protected)
- `PUT /api/v1/auth/profile` - Update user profile (protected)

### Projects

- `GET /api/v1/projects` - Get all projects (protected)
- `GET /api/v1/projects/:id` - Get project by ID (protected)
- `POST /api/v1/projects` - Create new project (admin only)
- `PUT /api/v1/projects/:id` - Update project (admin/supervisor)
- `DELETE /api/v1/projects/:id` - Delete project (admin only)

### Tasks

- `GET /api/v1/tasks` - Get all tasks (protected)
- `GET /api/v1/tasks?projectId=xxx` - Get tasks by project (protected)
- `GET /api/v1/tasks/:id` - Get task by ID (protected)
- `POST /api/v1/tasks` - Create new task (protected)
- `PUT /api/v1/tasks/:id` - Update task (protected)
- `DELETE /api/v1/tasks/:id` - Delete task (protected)

### Team

- `GET /api/v1/team` - Get all team members (protected)
- `GET /api/v1/team?projectId=xxx` - Get team by project (protected)
- `GET /api/v1/team/:id` - Get team member by ID (protected)
- `POST /api/v1/team` - Create new team member (admin only)
- `PUT /api/v1/team/:id` - Update team member (protected)
- `DELETE /api/v1/team/:id` - Delete team member (admin only)

### Health Check

- `GET /api/v1/health` - API health status

## 🔒 User Roles

- `super_admin` - Full system access
- `company_admin` - Company-wide management
- `supervisor` - Project management and oversight
- `operative` - Basic access, task execution

## 📝 Sample Request

### Register User

```bash
curl -X POST http://localhost:3001/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "name": "John Doe",
    "email": "john@example.com",
    "password": "password123",
    "role": "operative"
  }'
```

### Login

```bash
curl -X POST http://localhost:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@buildpro.com",
    "password": "password123"
  }'
```

### Get Projects (with token)

```bash
curl -X GET http://localhost:3001/api/v1/projects \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 🏗️ Project Structure

```text
backend/
├── src/
│   ├── config/
│   │   ├── database.ts      # Database connection
│   │   ├── logger.ts        # Winston logger setup
│   │   ├── migrate.ts       # Database migrations
│   │   └── seed.ts          # Database seeding
│   ├── controllers/
│   │   ├── authController.ts
│   │   ├── projectController.ts
│   │   ├── taskController.ts
│   │   └── teamController.ts
│   ├── middleware/
│   │   ├── auth.ts          # Authentication middleware
│   │   ├── errorHandler.ts # Error handling
│   │   └── validation.ts    # Request validation
│   ├── models/
│   │   ├── Project.ts
│   │   ├── Task.ts
│   │   ├── TeamMember.ts
│   │   └── User.ts
│   ├── routes/
│   │   ├── auth.ts
│   │   ├── projects.ts
│   │   ├── tasks.ts
│   │   ├── team.ts
│   │   └── index.ts
│   └── server.ts            # Express app setup
├── .env.example
├── .gitignore
├── package.json
├── tsconfig.json
└── README.md
```

## 🧪 Testing

```bash
npm test
```

## 🔧 Development Tools

- **TypeScript** - Type safety
- **tsx** - TypeScript execution for development
- **Express Validator** - Request validation
- **Winston** - Logging
- **Helmet** - Security headers
- **CORS** - Cross-origin resource sharing
- **bcryptjs** - Password hashing
- **jsonwebtoken** - JWT authentication

## 📊 Database Schema

### Users Table

- id, name, email, password_hash, phone, role, company_id, avatar_initials, avatar_url

### Projects Table

- id, name, code, description, location, type, status, health, progress, budget, spent, dates, manager, image, team_size, task metrics

### Tasks Table

- id, title, project_id, status, priority, assignee info, due_date, description

### Team Members Table

- id, name, initials, role, status, project_id, contact info, bio, skills, performance metrics

## 🚦 Error Handling

The API uses standardized error responses:

```json
{
  "status": "error",
  "message": "Error description"
}
```

Common HTTP status codes:

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `500` - Internal Server Error

## 📈 Logging

Logs are stored in:

- `logs/error.log` - Error logs only
- `logs/combined.log` - All logs

## 🔐 Security Features

- JWT authentication
- Password hashing with bcrypt
- Rate limiting (100 requests per 15 minutes)
- Helmet security headers
- CORS configuration
- Input validation and sanitization
- SQL injection prevention via parameterized queries

## 📄 License

MIT

## 👥 Default Credentials (Seeded Data)

After running the seed script, you can login with:

- **Email**: <john@buildpro.com>
- **Password**: password123
- **Role**: super_admin

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Support

For support, email <support@buildpro.com> or open an issue in the repository.
