# NOFX AI Trading System Commands
# Usage: just <command>

# Common command aliases
alias u := up
alias d := down
alias r := run
alias rs := restart
alias l := logs
alias s := status
alias b := build
alias t := test
alias tb := test-backend
alias tf := test-frontend
alias tc := test-coverage
alias bb := build-backend
alias bf := build-frontend
alias f := fmt
alias c := clean
alias h := health
alias o := open
alias ds := mkdocs-serve
alias doc := mkdocs-build

# Default command - list all available tasks
default:
    @just --list

# ===========================================
# Docker Service Management
# ===========================================

# Start all services
up:
    @echo "🐳 Starting NOFX services..."
    docker compose up -d
    @echo "✅ Services started"
    @just status

# Stop all services
down:
    @echo "🐳 Stopping NOFX services..."
    docker compose down
    @echo "✅ Services stopped"

# Restart all services
restart:
    @echo "🐳 Restarting NOFX services..."
    docker compose restart
    @just status

# Rebuild and start
build:
    @echo "🐳 Rebuilding NOFX images..."
    docker compose up -d --build

# Show service status
status:
    @echo "🐳 NOFX Service Status"
    @docker ps --filter "name=nofx" --format "table {{{{.Names}}}}\t{{{{.Status}}}}\t{{{{.Ports}}}}"

# View logs
logs service="nofx-trading":
    @echo "📋 Viewing {{service}} logs..."
    docker logs -f {{service}}

# View backend logs
logs-backend:
    @just logs nofx-trading

# View frontend logs
logs-frontend:
    @just logs nofx-frontend

# ===========================================
# Development Mode
# ===========================================

# Start backend in development mode
run:
    @echo "🚀 Starting backend in development mode..."
    go run main.go

# Start frontend in development mode
run-frontend:
    @echo "🚀 Starting frontend in development mode..."
    cd web && npm run dev

# Format code
fmt:
    @echo "🎨 Formatting Go code..."
    go fmt ./...
    @echo "🎨 Formatting frontend code..."
    cd web && npm run format 2>/dev/null || echo "ℹ️  No format script"

# Lint Go code (requires golangci-lint)
lint:
    @echo "🔍 Linting Go code..."
    golangci-lint run
    @echo "✅ Linting complete"

# ===========================================
# Dependency Management
# ===========================================

# Install Go dependencies
deps:
    @echo "📦 Installing Go dependencies..."
    go mod download
    @echo "✅ Dependencies installed"

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

# ===========================================
# Testing
# ===========================================

# Run all tests
test:
    @echo "🧪 Running backend tests..."
    go test -v ./...
    @echo "🧪 Running frontend tests..."
    cd web && npm run test
    @echo "✅ All tests complete"

# Run backend tests
test-backend:
    @echo "🧪 Running backend tests..."
    go test -v ./...

# Run frontend tests
test-frontend:
    @echo "🧪 Running frontend tests..."
    cd web && npm run test

# Generate coverage report
test-coverage:
    @echo "📊 Generating coverage report..."
    go test -coverprofile=coverage.out ./...
    go tool cover -html=coverage.out -o coverage.html
    @echo "✅ Coverage report: coverage.html"

# ===========================================
# Build
# ===========================================

# Build backend
build-backend:
    @echo "🔨 Building backend..."
    go build -o nofx
    @echo "✅ Backend built: ./nofx"

# Build frontend
build-frontend:
    @echo "🔨 Building frontend..."
    cd web && npm run build
    @echo "✅ Frontend built: ./web/dist"

# ===========================================
# Documentation
# ===========================================
NOFX_DOCUMENT_PORT := env_var_or_default("NOFX_DOCUMENT_PORT", "8000")
# Pin click==8.2.1 to fix livereload issue caused by Click 8.3.0
# See: https://github.com/squidfunk/mkdocs-material/issues/8478
# TODO: Migrate to Zensical when ready (MkDocs-Material is now in maintenance mode)
# See: https://github.com/squidfunk/mkdocs-material/issues/8523
_mkdocs := "uvx --from mkdocs --with click==8.2.1 --with mkdocs-material --with mkdocs-static-i18n --with mkdocs-git-revision-date-localized-plugin mkdocs"

# Start MkDocs documentation server
mkdocs-serve:
    @echo "📝 Checking and stopping services on port {{NOFX_DOCUMENT_PORT}}..."
    @-lsof -ti:{{NOFX_DOCUMENT_PORT}} | xargs kill -9 2>/dev/null || echo "ℹ️  No running MkDocs service detected"
    @echo "📝 Starting MkDocs documentation server (background)..."
    @mkdir -p runtime
    @rm -f runtime/mkdocs.log
    nohup {{_mkdocs}} serve --config-file mkdocs.yml --dev-addr 127.0.0.1:{{NOFX_DOCUMENT_PORT}} > runtime/mkdocs.log 2>&1 &
    @echo "✅ MkDocs server started: http://localhost:{{NOFX_DOCUMENT_PORT}} (log: runtime/mkdocs.log)"

# Stop MkDocs documentation server
mkdocs-stop:
    @echo "📝 Stopping MkDocs documentation server..."
    @-lsof -ti:{{NOFX_DOCUMENT_PORT}} | xargs kill -9 2>/dev/null || echo "ℹ️  No running MkDocs service detected"

# Build MkDocs static documentation
mkdocs-build:
    @echo "📝 Building MkDocs static documentation..."
    {{_mkdocs}} build --config-file mkdocs.yml --clean

# ===========================================
# Tools
# ===========================================

# Generate TOTP code
totp:
    @echo "🔑 Generating TOTP code..."
    @secret=$(grep NOFX_TEST_TOTP_SECRET .env | cut -d= -f2) && oathtool --totp -b "$secret"

# Clean build artifacts
clean:
    @echo "🧹 Cleaning build artifacts..."
    rm -f nofx coverage.out coverage.html
    rm -rf web/dist
    rm -rf site
    go clean -testcache
    @echo "✅ Clean complete"

# Health check
health:
    @echo "💊 Health check..."
    @curl -s http://localhost:8081/api/health && echo " ✅ Backend OK" || echo " ❌ Backend error"
    @curl -s http://localhost:3001/health && echo " ✅ Frontend OK" || echo " ❌ Frontend error"

# Open browser
open:
    @echo "🌐 Opening NOFX console..."
    @xdg-open http://localhost:3001 2>/dev/null || open http://localhost:3001 2>/dev/null || echo "ℹ️  Please visit http://localhost:3001"
