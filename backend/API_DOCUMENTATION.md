# BuildPro API Documentation

Version: 1.0.0  
Base URL: `http://localhost:3001/api/v1`

## Table of Contents

- [Authentication](#authentication)
- [Projects](#projects)
- [Tasks](#tasks)
- [Team](#team)
- [Error Handling](#error-handling)

---

## Authentication

All protected endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <token>
```

### Register User

**POST** `/auth/register`

Register a new user account.

**Request Body:**

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "+44 7700 900000",
  "role": "operative"
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+44 7700 900000",
      "role": "operative",
      "avatar_initials": "JD",
      "created_at": "2025-11-21T10:00:00.000Z"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Login

**POST** `/auth/login`

Login with email and password.

**Request Body:**

```json
{
  "email": "john@buildpro.com",
  "password": "password123"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "data": {
    "user": {
      "id": "u1",
      "name": "John Anderson",
      "email": "john@buildpro.com",
      "role": "super_admin"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

### Get Profile

**GET** `/auth/profile`

Get current user profile (requires authentication).

**Headers:**

```
Authorization: Bearer <token>
```

**Response:** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "u1",
    "name": "John Anderson",
    "email": "john@buildpro.com",
    "phone": "+44 7700 900001",
    "role": "super_admin",
    "avatar_initials": "JA"
  }
}
```

### Update Profile

**PUT** `/auth/profile`

Update current user profile (requires authentication).

**Headers:**

```
Authorization: Bearer <token>
```

**Request Body:**

```json
{
  "name": "John Anderson Updated",
  "phone": "+44 7700 900099"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "u1",
    "name": "John Anderson Updated",
    "phone": "+44 7700 900099"
  }
}
```

---

## Projects

### Get All Projects

**GET** `/projects`

Retrieve all projects (requires authentication).

**Headers:**

```
Authorization: Bearer <token>
```

**Response:** `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "id": "p1",
      "name": "City Centre Plaza Development",
      "code": "CCP-2025",
      "description": "A mixed-use development...",
      "location": "Downtown Metro",
      "type": "Commercial",
      "status": "Active",
      "health": "Good",
      "progress": 74,
      "budget": 25000000,
      "spent": 18500000,
      "start_date": "2025-01-15",
      "end_date": "2026-12-31",
      "manager": "John Anderson",
      "team_size": 24,
      "total_tasks": 145,
      "completed_tasks": 98,
      "overdue_tasks": 2,
      "created_at": "2025-11-21T10:00:00.000Z"
    }
  ]
}
```

### Get Project by ID

**GET** `/projects/:id`

Retrieve a specific project by ID.

**Headers:**

```
Authorization: Bearer <token>
```

**Response:** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "p1",
    "name": "City Centre Plaza Development",
    "code": "CCP-2025",
    ...
  }
}
```

### Create Project

**POST** `/projects`

Create a new project (requires admin role).

**Headers:**

```
Authorization: Bearer <token>
```

**Request Body:**

```json
{
  "name": "New Construction Project",
  "code": "NCP-2025",
  "description": "A new project description",
  "location": "City Center",
  "type": "Commercial",
  "status": "Planning",
  "health": "Good",
  "progress": 0,
  "budget": 5000000,
  "spent": 0,
  "start_date": "2025-12-01",
  "end_date": "2026-12-01",
  "manager": "John Anderson",
  "image": "https://example.com/image.jpg",
  "team_size": 10,
  "total_tasks": 0,
  "completed_tasks": 0,
  "overdue_tasks": 0
}
```

**Response:** `201 Created`

```json
{
  "success": true,
  "data": {
    "id": "generated-uuid",
    "name": "New Construction Project",
    ...
  }
}
```

### Update Project

**PUT** `/projects/:id`

Update an existing project (requires admin/supervisor role).

**Headers:**

```
Authorization: Bearer <token>
```

**Request Body:**

```json
{
  "progress": 80,
  "spent": 20000000,
  "status": "Active"
}
```

**Response:** `200 OK`

```json
{
  "success": true,
  "data": {
    "id": "p1",
    "progress": 80,
    "spent": 20000000,
    ...
  }
}
```

### Delete Project

**DELETE** `/projects/:id`

Delete a project (requires admin role).

**Headers:**

```
Authorization: Bearer <token>
```

**Response:** `200 OK`

```json
{
  "success": true,
  "message": "Project deleted successfully"
}
```

---

## Tasks

### Get All Tasks

**GET** `/tasks`

Retrieve all tasks or filter by project.

**Headers:**

```
Authorization: Bearer <token>
```

**Query Parameters:**

- `projectId` (optional): Filter tasks by project ID

**Example:** `/tasks?projectId=p1`

**Response:** `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "id": "t1",
      "title": "Safety inspection - Site A",
      "project_id": "p1",
      "status": "To Do",
      "priority": "High",
      "assignee_name": "Mike T.",
      "assignee_type": "user",
      "due_date": "2025-11-25",
      "created_at": "2025-11-21T10:00:00.000Z"
    }
  ]
}
```

### Get Task by ID

**GET** `/tasks/:id`

Retrieve a specific task.

**Headers:**

```
Authorization: Bearer <token>
```

**Response:** `200 OK`

### Create Task

**POST** `/tasks`

Create a new task.

**Headers:**

```
Authorization: Bearer <token>
```

**Request Body:**

```json
{
  "title": "New Task",
  "project_id": "p1",
  "status": "To Do",
  "priority": "High",
  "assignee_name": "John Doe",
  "assignee_type": "user",
  "due_date": "2025-12-01",
  "description": "Task description"
}
```

**Response:** `201 Created`

### Update Task

**PUT** `/tasks/:id`

Update an existing task.

**Headers:**

```
Authorization: Bearer <token>
```

**Request Body:**

```json
{
  "status": "In Progress",
  "assignee_name": "Jane Smith"
}
```

**Response:** `200 OK`

### Delete Task

**DELETE** `/tasks/:id`

Delete a task.

**Headers:**

```
Authorization: Bearer <token>
```

**Response:** `200 OK`

---

## Team

### Get All Team Members

**GET** `/team`

Retrieve all team members or filter by project.

**Headers:**

```
Authorization: Bearer <token>
```

**Query Parameters:**

- `projectId` (optional): Filter team members by project

**Response:** `200 OK`

```json
{
  "success": true,
  "data": [
    {
      "id": "tm1",
      "name": "John Anderson",
      "initials": "JA",
      "role": "Principal Admin",
      "status": "On Site",
      "project_id": "p1",
      "phone": "+44 7700 900001",
      "email": "john@buildpro.com",
      "color": "bg-[#0f5c82]",
      "bio": "20+ years in construction management...",
      "skills": ["Strategic Planning", "Budget Management"],
      "performance_rating": 98,
      "completed_projects": 42
    }
  ]
}
```

### Get Team Member by ID

**GET** `/team/:id`

Retrieve a specific team member.

**Headers:**

```
Authorization: Bearer <token>
```

**Response:** `200 OK`

### Create Team Member

**POST** `/team`

Create a new team member (requires admin role).

**Headers:**

```
Authorization: Bearer <token>
```

**Request Body:**

```json
{
  "name": "Jane Smith",
  "initials": "JS",
  "role": "Site Engineer",
  "status": "Off Site",
  "phone": "+44 7700 900100",
  "email": "jane@buildpro.com",
  "color": "bg-blue-500",
  "bio": "Experienced site engineer",
  "skills": ["AutoCAD", "Site Management"],
  "performance_rating": 85,
  "hourly_rate": 45.50
}
```

**Response:** `201 Created`

### Update Team Member

**PUT** `/team/:id`

Update a team member.

**Headers:**

```
Authorization: Bearer <token>
```

**Request Body:**

```json
{
  "status": "On Site",
  "project_id": "p1"
}
```

**Response:** `200 OK`

### Delete Team Member

**DELETE** `/team/:id`

Delete a team member (requires admin role).

**Headers:**

```
Authorization: Bearer <token>
```

**Response:** `200 OK`

---

## Error Handling

### Error Response Format

All errors follow this format:

```json
{
  "status": "error",
  "message": "Error description"
}
```

### HTTP Status Codes

- `200` - Success
- `201` - Created
- `400` - Bad Request (validation errors)
- `401` - Unauthorized (missing or invalid token)
- `403` - Forbidden (insufficient permissions)
- `404` - Not Found
- `429` - Too Many Requests (rate limit exceeded)
- `500` - Internal Server Error

### Common Errors

**Validation Error:**

```json
{
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ]
}
```

**Authentication Error:**

```json
{
  "error": "No token provided"
}
```

**Authorization Error:**

```json
{
  "error": "Insufficient permissions"
}
```

---

## Rate Limiting

API requests are limited to:

- **100 requests per 15 minutes** per IP address

When rate limit is exceeded:

```json
{
  "message": "Too many requests from this IP, please try again later."
}
```

---

## User Roles

- `super_admin` - Full system access
- `company_admin` - Company-wide management permissions
- `supervisor` - Project management and team oversight
- `operative` - Basic access for task execution

---

## Best Practices

1. Always include the JWT token in protected endpoints
2. Handle errors gracefully in your client application
3. Respect rate limits to avoid service disruption
4. Use HTTPS in production environments
5. Store JWT tokens securely (not in localStorage in production)
6. Implement token refresh mechanism for long sessions
7. Validate all user inputs on the client side before API calls

---

## Support

For API support or bug reports:

- Email: <support@buildpro.com>
- Documentation: <https://api.buildpro.com/docs>
