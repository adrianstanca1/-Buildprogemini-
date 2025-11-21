#!/bin/bash

# BuildPro Backend API Test Script
# Tests all API endpoints to verify functionality

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

API_URL="http://localhost:3001/api"
TOKEN=""
USER_ID=""
PROJECT_ID=""
TASK_ID=""

# Print functions
print_test() {
    echo -e "${BLUE}▶${NC} Testing: $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_section() {
    echo ""
    echo "======================================"
    echo "$1"
    echo "======================================"
}

# Test health check
test_health() {
    print_test "Health Check"
    RESPONSE=$(curl -s "${API_URL}/health")
    if echo "$RESPONSE" | grep -q "ok"; then
        print_success "Health check passed"
        return 0
    else
        print_error "Health check failed"
        return 1
    fi
}

# Test user registration
test_register() {
    print_test "User Registration"
    RESPONSE=$(curl -s -X POST "${API_URL}/auth/register" \
        -H "Content-Type: application/json" \
        -d '{
            "name": "Test User",
            "email": "test@example.com",
            "password": "password123",
            "role": "admin"
        }')
    
    if echo "$RESPONSE" | grep -q "token"; then
        TOKEN=$(echo "$RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
        USER_ID=$(echo "$RESPONSE" | grep -o '"id":"[^"]*"' | cut -d'"' -f4)
        print_success "User registered successfully"
        return 0
    else
        print_error "Registration failed: $RESPONSE"
        return 1
    fi
}

# Test user login
test_login() {
    print_test "User Login"
    RESPONSE=$(curl -s -X POST "${API_URL}/auth/login" \
        -H "Content-Type: application/json" \
        -d '{
            "email": "test@example.com",
            "password": "password123"
        }')
    
    if echo "$RESPONSE" | grep -q "token"; then
        TOKEN=$(echo "$RESPONSE" | grep -o '"token":"[^"]*"' | cut -d'"' -f4)
        print_success "Login successful"
        return 0
    else
        print_error "Login failed: $RESPONSE"
        return 1
    fi
}

# Test get current user
test_get_user() {
    print_test "Get Current User"
    RESPONSE=$(curl -s -X GET "${API_URL}/auth/me" \
        -H "Authorization: Bearer ${TOKEN}")
    
    if echo "$RESPONSE" | grep -q "email"; then
        print_success "User retrieved successfully"
        return 0
    else
        print_error "Get user failed: $RESPONSE"
        return 1
    fi
}

# Test create project
test_create_project() {
    print_test "Create Project"
    RESPONSE=$(curl -s -X POST "${API_URL}/projects" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${TOKEN}" \
        -d '{
            "name": "Test Construction Project",
            "description": "A test project for API verification",
            "location": "London, UK",
            "status": "active",
            "startDate": "2025-01-01",
            "endDate": "2025-12-31",
            "budget": 1000000,
            "managerId": "'${USER_ID}'"
        }')
    
    if echo "$RESPONSE" | grep -q "success"; then
        PROJECT_ID=$(echo "$RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        print_success "Project created successfully (ID: ${PROJECT_ID})"
        return 0
    else
        print_error "Create project failed: $RESPONSE"
        return 1
    fi
}

# Test get all projects
test_get_projects() {
    print_test "Get All Projects"
    RESPONSE=$(curl -s -X GET "${API_URL}/projects" \
        -H "Authorization: Bearer ${TOKEN}")
    
    if echo "$RESPONSE" | grep -q "success"; then
        print_success "Projects retrieved successfully"
        return 0
    else
        print_error "Get projects failed: $RESPONSE"
        return 1
    fi
}

# Test create task
test_create_task() {
    print_test "Create Task"
    RESPONSE=$(curl -s -X POST "${API_URL}/tasks" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${TOKEN}" \
        -d '{
            "projectId": "'${PROJECT_ID}'",
            "title": "Foundation Work",
            "description": "Excavation and foundation laying",
            "status": "pending",
            "priority": "high",
            "assignedTo": "'${USER_ID}'",
            "dueDate": "2025-02-01"
        }')
    
    if echo "$RESPONSE" | grep -q "success"; then
        TASK_ID=$(echo "$RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)
        print_success "Task created successfully (ID: ${TASK_ID})"
        return 0
    else
        print_error "Create task failed: $RESPONSE"
        return 1
    fi
}

# Test get tasks
test_get_tasks() {
    print_test "Get All Tasks"
    RESPONSE=$(curl -s -X GET "${API_URL}/tasks?projectId=${PROJECT_ID}" \
        -H "Authorization: Bearer ${TOKEN}")
    
    if echo "$RESPONSE" | grep -q "success"; then
        print_success "Tasks retrieved successfully"
        return 0
    else
        print_error "Get tasks failed: $RESPONSE"
        return 1
    fi
}

# Test update task
test_update_task() {
    print_test "Update Task Status"
    RESPONSE=$(curl -s -X PUT "${API_URL}/tasks/${TASK_ID}" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${TOKEN}" \
        -d '{
            "status": "in-progress"
        }')
    
    if echo "$RESPONSE" | grep -q "success"; then
        print_success "Task updated successfully"
        return 0
    else
        print_error "Update task failed: $RESPONSE"
        return 1
    fi
}

# Test add team member
test_add_team_member() {
    print_test "Add Team Member"
    RESPONSE=$(curl -s -X POST "${API_URL}/team" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${TOKEN}" \
        -d '{
            "projectId": "'${PROJECT_ID}'",
            "userId": "'${USER_ID}'",
            "role": "Project Manager",
            "permissions": ["read", "write", "admin"]
        }')
    
    if echo "$RESPONSE" | grep -q "success"; then
        print_success "Team member added successfully"
        return 0
    else
        print_error "Add team member failed: $RESPONSE"
        return 1
    fi
}

# Test get team members
test_get_team() {
    print_test "Get Team Members"
    RESPONSE=$(curl -s -X GET "${API_URL}/team?projectId=${PROJECT_ID}" \
        -H "Authorization: Bearer ${TOKEN}")
    
    if echo "$RESPONSE" | grep -q "success"; then
        print_success "Team members retrieved successfully"
        return 0
    else
        print_error "Get team failed: $RESPONSE"
        return 1
    fi
}

# Main test execution
main() {
    print_section "BuildPro API Test Suite"
    
    echo "API URL: ${API_URL}"
    echo ""
    
    # Check if server is running
    if ! curl -s "${API_URL}/health" > /dev/null 2>&1; then
        print_error "Backend server is not running!"
        echo "Please start the server with: npm run dev"
        exit 1
    fi
    
    PASSED=0
    FAILED=0
    
    # Run tests
    print_section "Authentication Tests"
    test_health && ((PASSED++)) || ((FAILED++))
    test_register && ((PASSED++)) || ((FAILED++))
    test_login && ((PASSED++)) || ((FAILED++))
    test_get_user && ((PASSED++)) || ((FAILED++))
    
    print_section "Project Tests"
    test_create_project && ((PASSED++)) || ((FAILED++))
    test_get_projects && ((PASSED++)) || ((FAILED++))
    
    print_section "Task Tests"
    test_create_task && ((PASSED++)) || ((FAILED++))
    test_get_tasks && ((PASSED++)) || ((FAILED++))
    test_update_task && ((PASSED++)) || ((FAILED++))
    
    print_section "Team Tests"
    test_add_team_member && ((PASSED++)) || ((FAILED++))
    test_get_team && ((PASSED++)) || ((FAILED++))
    
    # Summary
    print_section "Test Summary"
    echo -e "${GREEN}Passed: ${PASSED}${NC}"
    echo -e "${RED}Failed: ${FAILED}${NC}"
    echo "Total:  $((PASSED + FAILED))"
    
    if [ $FAILED -eq 0 ]; then
        echo ""
        echo -e "${GREEN}All tests passed! ✓${NC}"
        exit 0
    else
        echo ""
        echo -e "${RED}Some tests failed ✗${NC}"
        exit 1
    fi
}

main
