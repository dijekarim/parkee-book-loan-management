# Book Loan Management System

A full-stack book loan management application built with Ruby on Rails (API) backend and Vue.js frontend. The system allows libraries to manage books, borrowers, and loan transactions with comprehensive tracking and validation.

## 🏗️ Architecture

```
book-loan-management/
├── backend/          # Ruby on Rails API (Port 4000)
│   ├── app/
│   │   ├── models/
│   │   │   ├── book.rb
│   │   │   ├── borrower.rb
│   │   │   └── loan.rb
│   │   └── controllers/
│   ├── config/
│   ├── db/
│   ├── Dockerfile
│   └── docker-compose.yml
└── frontend/         # Vue.js SPA (Port 5173)
    ├── src/
    │   ├── views/
    │   │   ├── BooksView.vue
    │   │   ├── BorrowersView.vue
    │   │   ├── LoansView.vue
    │   │   └── HomeView.vue
    │   └── App.vue
    └── package.json
```

## 🚀 Features

### Books Management
- **CRUD Operations**: Create, read, update, and delete books
- **Search Functionality**: Search books by title or ISBN
- **Stock Management**: Track available stock for each book
- **Validation**: Ensure title, ISBN, and stock are properly set

### Borrowers Management
- **Member Registration**: Register new borrowers with unique card numbers
- **Profile Management**: Manage borrower information (name, email, card number)
- **Search Capability**: Find borrowers by name, email, or card number
- **Unique Constraints**: Prevent duplicate emails and card numbers

### Loan Management
- **Loan Creation**: Issue books to borrowers with automatic date tracking
- **Return Processing**: Process book returns with timestamp tracking
- **Business Rules**:
  - One active loan per borrower at a time
  - Maximum loan duration of 30 days
  - Stock availability validation
  - Automatic borrow date setting

### Dashboard & Analytics
- Overview of system statistics
- Active loans tracking
- Available inventory monitoring

## 🛠️ Technology Stack

### Backend (Ruby on Rails 8.0)
- **Framework**: Ruby on Rails 8.0.3 (API mode)
- **Database**: PostgreSQL
- **Ruby Version**: 3.3.3
- **Key Gems**:
  - `pg` - PostgreSQL adapter
  - `puma` - Web server
  - `pagy` - Pagination
  - `rack-cors` - CORS handling
  - `solid_cache` - Database-backed caching
  - `solid_queue` - Background jobs
  - `rspec-rails` - Testing framework
  - `factory_bot_rails` - Test factories
  - `rubocop-rails-omakase` - Code style

### Frontend (Vue.js 3)
- **Framework**: Vue.js 3.5.18
- **Build Tool**: Vite 7.0.6
- **Router**: Vue Router 4.5.1
- **Styling**: Tailwind CSS 4.1.13
- **Code Quality**: ESLint + Prettier
- **Node Version**: ^20.19.0 || >=22.12.0

### Database Schema
- **books**: title, isbn, stock, timestamps
- **borrowers**: card_number, name, email, timestamps
- **loans**: borrower_id, book_id, borrow_date, return_date, returned_at, timestamps

## 🐳 Docker Setup (Recommended)

### Prerequisites
- Docker
- Docker Compose

### Quick Start with Docker

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd book-loan-management
   ```

2. **Start all services (Database + Backend + Frontend)**
   ```bash
   docker-compose up -d
   ```

3. **Setup the database**
   ```bash
   # Run migrations
   docker-compose exec backend rails db:create db:migrate
   
   # (Optional) Seed sample data
   docker-compose exec backend rails db:seed
   ```

4. **Access the application**
   - Frontend: http://localhost:5173
   - Backend API: http://localhost:4000
   - API Health Check: http://localhost:4000/up
   - Database: localhost:5432 (postgres/password)

### Alternative: Backend Only Docker Setup

If you prefer to run the frontend manually:

1. **Start backend services only**
   ```bash
   cd backend
   docker-compose up -d
   ```

2. **Setup database**
   ```bash
   docker-compose exec web rails db:create db:migrate db:seed
   ```

3. **Start frontend manually**
   ```bash
   cd frontend
   npm install
   npm run dev
   ```

### Docker Services

#### Backend Services (docker-compose.yml)
- **web**: Rails application container
  - Port: 4000
  - Database: PostgreSQL
  - Environment variables for database connection
- **db**: PostgreSQL database
  - Image: postgres:latest
  - Data persistence with named volume
  - Health checks configured

### Docker Commands

#### Full Stack Commands (Root Level)
```bash
# Start all services (database, backend, frontend)
docker-compose up -d

# View logs for all services
docker-compose logs -f

# View logs for specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f db

# Access Rails console
docker-compose exec backend rails console

# Run backend tests
docker-compose exec backend rspec

# Stop all services
docker-compose down

# Reset database
docker-compose exec backend rails db:drop db:create db:migrate db:seed

# Rebuild services after code changes
docker-compose build
docker-compose up -d
```

#### Backend Only Commands (Backend Directory)
```bash
# Start backend services only
cd backend
docker-compose up -d

# View logs
docker-compose logs -f

# Access Rails console
docker-compose exec web rails console

# Run tests
docker-compose exec web rspec

# Stop services
docker-compose down
```

## 🛠️ Manual Setup (Alternative)

### Backend Setup

1. **Prerequisites**
   - Ruby 3.3.3
   - PostgreSQL
   - Bundler

2. **Installation**
   ```bash
   cd backend
   bundle install
   ```

3. **Database Setup**
   ```bash
   # Configure your database credentials in config/database.yml
   rails db:create
   rails db:migrate
   rails db:seed  # Optional: Load sample data
   ```

4. **Start the server**
   ```bash
   rails server -p 4000
   ```

### Frontend Setup

1. **Prerequisites**
   - Node.js (^20.19.0 || >=22.12.0)
   - npm

2. **Installation**
   ```bash
   cd frontend
   npm install
   ```

3. **Development Server**
   ```bash
   npm run dev
   ```

4. **Build for Production**
   ```bash
   npm run build
   ```

## 🌐 API Endpoints

### Books
- `GET /api/v1/books` - List all books (with search support)
- `POST /api/v1/books` - Create a new book
- `GET /api/v1/books/:id` - Get book details
- `PATCH/PUT /api/v1/books/:id` - Update book
- `DELETE /api/v1/books/:id` - Delete book

### Borrowers
- `GET /api/v1/borrowers` - List all borrowers (with search support)
- `POST /api/v1/borrowers` - Register new borrower
- `GET /api/v1/borrowers/:id` - Get borrower details
- `PATCH/PUT /api/v1/borrowers/:id` - Update borrower
- `DELETE /api/v1/borrowers/:id` - Delete borrower

### Loans
- `GET /api/v1/loans` - List all loans
- `POST /api/v1/loans` - Create new loan
- `GET /api/v1/loans/:id` - Get loan details
- `PATCH/PUT /api/v1/loans/:id` - Update loan
- `PATCH /api/v1/loans/:id/return` - Process book return
- `DELETE /api/v1/loans/:id` - Delete loan

### Dashboard
- `GET /api/v1/dashboard` - Get system overview statistics

## 🧪 Testing

### Backend Tests
```bash
# Using Docker
docker-compose exec web rspec

# Manual setup
cd backend
bundle exec rspec
```

### Frontend Tests
```bash
cd frontend
npm run lint
```

## 🔧 Development Tools

### Backend
- **RuboCop**: Code style and linting
- **Brakeman**: Security vulnerability scanning
- **RSpec**: Testing framework
- **Factory Bot**: Test data factories
- **Annotate**: Model annotation

### Frontend
- **ESLint**: JavaScript linting
- **Prettier**: Code formatting
- **Vue DevTools**: Browser extension for Vue.js debugging

## 📝 Business Rules

1. **Borrower Constraints**:
   - Each borrower can only have one active loan at a time
   - Unique email addresses and card numbers required

2. **Loan Constraints**:
   - Maximum loan duration: 30 days
   - Books must be in stock (stock > 0)
   - Automatic borrow date assignment

3. **Book Management**:
   - Stock levels automatically tracked
   - Search functionality by title and ISBN

## 🚀 Deployment

### Using Kamal (Recommended for Production)
The backend includes Kamal gem for easy Docker-based deployment:

```bash
# Configure your deployment settings
kamal setup

# Deploy the application
kamal deploy
```

### Manual Docker Deployment
```bash
# Build and push images
docker build -t book-loan-backend ./backend
docker build -t book-loan-frontend ./frontend

# Deploy using your preferred orchestration tool
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Troubleshooting

### Common Issues

**Database Connection Issues (Docker)**:
```bash
# Ensure database is running
docker-compose ps
docker-compose exec db pg_isready

# Reset database
docker-compose exec web rails db:reset
```

**Port Conflicts**:
- Backend runs on port 4000
- Frontend runs on port 5173
- PostgreSQL runs on port 5432 (internal to Docker)

**CORS Issues**:
- Backend includes `rack-cors` configuration
- Ensure frontend URL is allowed in CORS settings

**Node Version Issues**:
```bash
# Use nvm to manage Node versions
nvm install 20
nvm use 20
```

## 📞 Support

For support and questions, please open an issue in the repository or contact the development team.