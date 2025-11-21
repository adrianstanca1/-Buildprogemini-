.PHONY: help install setup start dev build test migrate seed clean status check-api docker-up docker-down docker-reset

# Default target
help:
	@echo "BuildPro Backend - Available Commands"
	@echo "======================================"
	@echo ""
	@echo "Setup & Installation:"
	@echo "  make install      - Install dependencies"
	@echo "  make setup        - Full automated setup"
	@echo ""
	@echo "Development:"
	@echo "  make dev          - Start development server"
	@echo "  make build        - Build TypeScript"
	@echo "  make start        - Start production server"
	@echo ""
	@echo "Database:"
	@echo "  make migrate      - Run database migrations"
	@echo "  make seed         - Seed database with test data"
	@echo "  make docker-up    - Start PostgreSQL container"
	@echo "  make docker-down  - Stop PostgreSQL container"
	@echo "  make docker-reset - Reset database (removes all data)"
	@echo ""
	@echo "Testing & Utilities:"
	@echo "  make test         - Run tests"
	@echo "  make check-api    - Test API endpoints"
	@echo "  make status       - Check system status"
	@echo "  make clean        - Clean build artifacts"
	@echo ""

# Installation
install:
	@echo "Installing dependencies..."
	npm install
	@echo "✓ Dependencies installed"

# Full setup
setup:
	@echo "Running full setup..."
	chmod +x setup-backend.sh
	./setup-backend.sh

# Development
dev:
	npm run dev

build:
	npm run build

start:
	npm start

# Database
migrate:
	npm run migrate

seed:
	npm run seed

# Docker
docker-up:
	docker-compose up -d
	@echo "Waiting for PostgreSQL to be ready..."
	@sleep 5
	@echo "✓ PostgreSQL is running"

docker-down:
	docker-compose down

docker-reset:
	@echo "⚠️  WARNING: This will delete all database data!"
	@read -p "Continue? [y/N] " -n 1 -r; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose down -v; \
		docker-compose up -d; \
		sleep 5; \
		make migrate; \
		make seed; \
		echo "✓ Database reset complete"; \
	fi

# Testing
test:
	npm test

check-api:
	chmod +x test-api.sh
	./test-api.sh

status:
	chmod +x check-status.sh
	./check-status.sh

# Cleanup
clean:
	@echo "Cleaning build artifacts..."
	rm -rf dist
	rm -rf node_modules
	rm -rf logs/*.log
	@echo "✓ Clean complete"

# Quick shortcuts
.PHONY: up down reset
up: docker-up
down: docker-down
reset: docker-reset
