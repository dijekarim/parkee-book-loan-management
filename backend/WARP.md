# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a **Rails 8 API-only application** for library loan management. The application is configured as a modern Rails API with PostgreSQL database support and includes deployment via Kamal.

## Architecture Overview

### Application Structure
- **API-Only Rails Application**: Configured with `config.api_only = true`, excluding views, helpers, and assets
- **Database**: PostgreSQL with multi-database setup (primary, cache, queue, cable databases)
- **Background Jobs**: Uses Solid Queue for job processing, configured to run within Puma process (`SOLID_QUEUE_IN_PUMA: true`)
- **Caching**: Solid Cache for database-backed caching
- **WebSocket**: Solid Cable for Action Cable functionality
- **Deployment**: Kamal for containerized deployment

### Key Configuration
- **Module**: `LibraryLoanManagement::Application`
- **Ruby Version**: Uses `.ruby-version` file (currently empty - should be set)
- **Autoloading**: Zeitwerk-compliant structure with `config.autoload_lib(ignore: %w[assets tasks])`
- **Database Environments**: 
  - Development: `library_loan_management_development`
  - Test: `library_loan_management_test` 
  - Production: Multi-database setup with separate databases for cache, queue, and cable

## Development Commands

### Setup and Installation
```bash
# Install dependencies
bundle install

# Setup database
bin/rails db:setup

# Create databases only
bin/rails db:create

# Run migrations
bin/rails db:migrate

# Seed the database
bin/rails db:seed
```

### Running the Application
```bash
# Start the Rails server
bin/rails server
# or
bin/rails s

# Start Rails console
bin/rails console
# or
bin/rails c

# Start database console
bin/rails dbconsole
# or
bin/rails db
```

### Testing
```bash
# Run all tests
bin/rails test

# Run all tests including system tests
bin/rails test:all

# Run specific test types
bin/rails test:models
bin/rails test:controllers
bin/rails test:integration

# Reset database and run tests
bin/rails test:db
```

### Database Management
```bash
# Check migration status
bin/rails db:migrate:status

# Rollback migrations
bin/rails db:rollback STEP=1

# Reset database (drop, create, migrate, seed)
bin/rails db:reset

# Prepare database (setup if doesn't exist, or migrate if it does)
bin/rails db:prepare

# Load fixtures
bin/rails db:fixtures:load
```

### Code Quality and Linting
```bash
# Run Rubocop (uses rails-omakase configuration)
bin/rubocop

# Auto-correct Rubocop offenses
bin/rubocop -A

# Run Brakeman security scanner
bin/brakeman
```

### Background Jobs (Solid Queue)
```bash
# Start Solid Queue supervisor manually (if not using SOLID_QUEUE_IN_PUMA)
bin/rails solid_queue:start

# Note: In this app, Solid Queue runs inside Puma process by default
```

### Development Tools
```bash
# Generate new resources (API-only)
bin/rails generate controller API::Books
bin/rails generate model Book title:string author:string

# Show all routes
bin/rails routes

# Show middleware stack  
bin/rails middleware

# Clear logs
bin/rails log:clear

# Clear tmp files
bin/rails tmp:clear

# Check Zeitwerk compatibility
bin/rails zeitwerk:check
```

### Deployment (Kamal)
```bash
# Deploy application
bin/kamal deploy

# Check application status
bin/kamal app details

# View logs
bin/kamal logs
# or use alias
bin/kamal logs

# Access Rails console in production
bin/kamal console
# or use alias defined in deploy.yml

# Access shell in production
bin/kamal shell

# Access database console in production  
bin/kamal dbc
```

## Development Patterns

### API Structure
- Follow Rails API conventions with controllers in `app/controllers/`
- Use namespace controllers (e.g., `API::V1::BooksController`) for versioned APIs
- Leverage Rails serializers or custom JSON rendering for API responses

### Database Patterns
- Multi-database configuration is already set up for production scaling
- Use ActiveRecord migrations for schema changes
- Leverage database-backed features (Solid Cache, Queue, Cable) for production efficiency

### Background Processing
- Jobs inherit from `ApplicationJob` 
- Solid Queue is configured to run within Puma in development/single-server deployments
- For multi-server deployments, extract job processing to dedicated machines

### Error Handling and Health Checks
- Built-in health check endpoint at `/up` returns 200/500 based on application boot status
- Use for load balancer and uptime monitoring

## Environment Configuration

### Required Environment Variables (Production)
- `RAILS_MASTER_KEY`: For credentials encryption
- `KAMAL_REGISTRY_PASSWORD`: For container registry access
- `LIBRARY_LOAN_MANAGEMENT_DATABASE_PASSWORD`: For production database access

### Optional Configuration
- `RAILS_LOG_LEVEL`: Control logging verbosity
- `WEB_CONCURRENCY`: Set Puma process count
- `JOB_CONCURRENCY`: Set Solid Queue worker count
- `DB_HOST`: External database host configuration