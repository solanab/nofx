# NOFX Makefile for testing and development

.PHONY: help test test-backend test-frontend test-coverage clean
.PHONY: build build-frontend run run-frontend fmt lint
.PHONY: docker-build docker-up docker-down docker-logs docker-status docker-restart
.PHONY: deps deps-update deps-frontend
.PHONY: mkdocs-serve mkdocs-build mkdocs-stop
.PHONY: totp health open

# Default target
help:
	@echo "NOFX Testing & Development Commands"
	@echo ""
	@echo "Testing:"
	@echo "  make test                 - Run all tests (backend + frontend)"
	@echo "  make test-backend         - Run backend tests only"
	@echo "  make test-frontend        - Run frontend tests only"
	@echo "  make test-coverage        - Generate backend coverage report"
	@echo ""
	@echo "Build:"
	@echo "  make build                - Build backend binary"
	@echo "  make build-frontend       - Build frontend"
	@echo ""
	@echo "Development:"
	@echo "  make run                  - Run backend in development mode"
	@echo "  make run-frontend         - Run frontend in development mode"
	@echo "  make fmt                  - Format Go code"
	@echo "  make lint                 - Lint Go code (requires golangci-lint)"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-up            - Start Docker containers"
	@echo "  make docker-down          - Stop Docker containers"
	@echo "  make docker-build         - Build Docker images"
	@echo "  make docker-restart       - Restart Docker containers"
	@echo "  make docker-status        - Show Docker container status"
	@echo "  make docker-logs          - View Docker logs"
	@echo ""
	@echo "Documentation:"
	@echo "  make mkdocs-serve         - Serve documentation with live reload"
	@echo "  make mkdocs-build         - Build documentation for production"
	@echo "  make mkdocs-stop          - Stop documentation server"
	@echo ""
	@echo "Dependencies:"
	@echo "  make deps                 - Download Go dependencies"
	@echo "  make deps-update          - Update Go dependencies"
	@echo "  make deps-frontend        - Install frontend dependencies"
	@echo ""
	@echo "Tools:"
	@echo "  make totp                 - Generate TOTP verification code"
	@echo "  make health               - Check service health"
	@echo "  make open                 - Open NOFX in browser"
	@echo ""
	@echo "Clean:"
	@echo "  make clean                - Clean build artifacts and test cache"

# =============================================================================
# Testing
# =============================================================================

# Run all tests
test:
	@echo "🧪 Running backend tests..."
	go test -v ./...
	@echo ""
	@echo "🧪 Running frontend tests..."
	cd web && npm run test
	@echo "✅ All tests completed"

# Backend tests only
test-backend:
	@echo "🧪 Running backend tests..."
	go test -v ./...

# Frontend tests only
test-frontend:
	@echo "🧪 Running frontend tests..."
	cd web && npm run test

# Coverage report
test-coverage:
	@echo "📊 Generating coverage..."
	go test -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html
	@echo "✅ Backend coverage: coverage.html"

# =============================================================================
# Build
# =============================================================================

# Build backend binary
build:
	@echo "🔨 Building backend..."
	go build -o nofx
	@echo "✅ Backend built: ./nofx"

# Build frontend
build-frontend:
	@echo "🔨 Building frontend..."
	cd web && npm run build
	@echo "✅ Frontend built: ./web/dist"

# =============================================================================
# Development
# =============================================================================

# Run backend in development mode
run:
	@echo "🚀 Starting backend..."
	go run main.go

# Run frontend in development mode
run-frontend:
	@echo "🚀 Starting frontend dev server..."
	cd web && npm run dev

# Format Go code
fmt:
	@echo "🎨 Formatting Go code..."
	go fmt ./...
	@echo "✅ Code formatted"

# Lint Go code (requires golangci-lint)
lint:
	@echo "🔍 Linting Go code..."
	golangci-lint run
	@echo "✅ Linting completed"

# =============================================================================
# Clean
# =============================================================================

clean:
	@echo "🧹 Cleaning..."
	rm -f nofx
	rm -f coverage.out coverage.html
	rm -rf web/dist
	rm -rf site
	go clean -testcache
	@echo "✅ Cleaned"

# =============================================================================
# Docker
# =============================================================================

# Start Docker containers
docker-up:
	@echo "🐳 Starting NOFX services..."
	docker compose up -d
	@echo "✅ Services started"
	@$(MAKE) docker-status

# Stop Docker containers
docker-down:
	@echo "🐳 Stopping NOFX services..."
	docker compose down
	@echo "✅ Services stopped"

# Build Docker images
docker-build:
	@echo "🐳 Building NOFX images..."
	docker compose up -d --build

# Restart Docker containers
docker-restart:
	@echo "🐳 Restarting NOFX services..."
	docker compose restart
	@$(MAKE) docker-status

# Show Docker container status
docker-status:
	@echo "🐳 NOFX service status"
	@docker ps --filter "name=nofx" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# View Docker logs
docker-logs:
	docker compose logs -f

# =============================================================================
# Dependencies
# =============================================================================

# Download Go dependencies
deps:
	@echo "📦 Downloading Go dependencies..."
	go mod download
	@echo "✅ Dependencies downloaded"

# Update Go dependencies
deps-update:
	@echo "📦 Updating Go dependencies..."
	go get -u ./...
	go mod tidy
	@echo "✅ Dependencies updated"

# Install frontend dependencies
deps-frontend:
	@echo "📦 Installing frontend dependencies..."
	cd web && npm install
	@echo "✅ Frontend dependencies installed"

# =============================================================================
# Documentation
# =============================================================================

NOFX_DOCUMENT_PORT ?= 8000
# Pin click==8.2.1 to fix livereload issue caused by Click 8.3.0
# See: https://github.com/squidfunk/mkdocs-material/issues/8478
# TODO: Migrate to Zensical when ready (MkDocs-Material is now in maintenance mode)
# See: https://github.com/squidfunk/mkdocs-material/issues/8523
MKDOCS_CMD = uvx --from mkdocs --with click==8.2.1 --with mkdocs-material --with mkdocs-static-i18n --with mkdocs-git-revision-date-localized-plugin mkdocs

# Serve documentation with live reload
mkdocs-serve:
	@echo "📝 Checking port $(NOFX_DOCUMENT_PORT)..."
	@-lsof -ti:$(NOFX_DOCUMENT_PORT) | xargs kill -9 2>/dev/null || echo "ℹ️  No running MkDocs service detected"
	@echo "📝 Starting MkDocs service (background)..."
	@mkdir -p runtime
	nohup $(MKDOCS_CMD) serve --config-file mkdocs.yml --dev-addr 127.0.0.1:$(NOFX_DOCUMENT_PORT) > runtime/mkdocs.log 2>&1 &
	@echo "✅ MkDocs started: http://localhost:$(NOFX_DOCUMENT_PORT) (log: runtime/mkdocs.log)"

# Build documentation for production
mkdocs-build:
	@echo "📝 Building MkDocs static documentation..."
	$(MKDOCS_CMD) build --config-file mkdocs.yml --clean

# Stop documentation server
mkdocs-stop:
	@echo "📝 Stopping MkDocs service..."
	@-lsof -ti:$(NOFX_DOCUMENT_PORT) | xargs kill -9 2>/dev/null || echo "ℹ️  No running MkDocs service detected"

# =============================================================================
# Tools
# =============================================================================

# Generate TOTP verification code
totp:
	@echo "🔑 Generating TOTP code..."
	@secret=$$(grep NOFX_TEST_TOTP_SECRET .env | cut -d= -f2) && oathtool --totp -b "$$secret"

# Check service health
health:
	@echo "💊 Health check..."
	@curl -s http://localhost:8081/api/health && echo " ✅ backend OK" || echo " ❌ backend FAIL"
	@curl -s http://localhost:3001/health && echo " ✅ frontend OK" || echo " ❌ frontend FAIL"

# Open NOFX in browser
open:
	@echo "🌐 Opening NOFX console..."
	@xdg-open http://localhost:3001 2>/dev/null || open http://localhost:3001 2>/dev/null || echo "ℹ️  Please visit http://localhost:3001"
