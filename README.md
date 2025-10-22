# Rails API Application

This is a Ruby on Rails **8.0.3** application built as a **JSON API backend** using the [Grape](https://github.com/ruby-grape/grape) framework.  
All API responses follow the [JSON:API](https://jsonapi.org/) specification and are secured using **JWT** tokens.
Business logic is organized using the [Interactor](https://github.com/collectiveidea/interactor) gem.

---

## Requirements

- **Ruby:** 3.4.5
- **Rails:** 8.0.3
- **Database:** PostgreSQL

---

## Configuration

Before running the application, make sure you have:

1. Installed all required dependencies:
   ```bash
   bundle install 
   ```
2. Set up your database connection in config/database.yml.   

## Database Setup

Create and initialize the database:
   ```bash
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:test:prepare
   ```

## Running the Application

Start the Rails server:

```bash
bin/rails server
```
By default, the API will be available at:
http://localhost:3000

## API

- The API is implemented using the Grape gem.
- The OpenAPI / Swagger documentation is located at:

http://localhost:3000/swagger

- All responses follow the JSON:API format.
- Requests are authenticated using JWT tokens.

## API Logs
- Logs store information for balance operations. 
- Logs are located in the `log/api_[env].log` file.

Log example [log/api_development.log]:
   ```bash
[2025-10-22 12:35:05] INFO: [update balance][user 1] amount: 220.0, new balance: 235.0
[2025-10-22 12:35:11] INFO: [update balance][user 1] amount: -20.0, new balance: 215.0
[2025-10-22 12:35:19] INFO: [transfer balance][user 1 → 2}] amount: 5.0
[2025-10-22 12:35:30] INFO: [transfer balance][user 1 → 2}] amount: 10.0
   ```


## Running Tests

Run the test suite with:
   ```bash
bundle exec rspec
   ```

## Code Quality

Run RuboCop to check for linting and style issues:
   ```bash
bundle exec rubocop
   ``` 

## Project Structure
   ```bash
app/
├── api/                # Grape API endpoints
├── models/             # ActiveRecord models
├── serializers/        # JSONAPI serializers
├── interactors/        # Business logic using Interactor gem
├── organizers/         # Organizers for complex workflows (Interactor pattern)
├── lib/                # Custom modules and utilities
spec/                   # RSpec tests
config/                 # App configuration files
   ``` 

## Using the API

## Auth

### Register a new user
   ```bash
POST /api/v1/auth/register
Content-Type: application/json

Body:
{
"email": "user@example.com"
}
   ```

CURL Example:
   ```bash
curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d '{"email":"testing@example.com"}' 'http://localhost:3000/api/v1/auth/register'
   ```
Response Body:
   ```json
{
  "data": {
    "id": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ1ODV9.MD249hJUIgOJGa82uXQPUbJDsMYMZXpAhaTgBF2Utrk",
    "type": "token",
    "attributes": {
      "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ1ODV9.MD249hJUIgOJGa82uXQPUbJDsMYMZXpAhaTgBF2Utrk"
    }
  }
}
   ```

---

### Login
   ```bash
POST /api/v1/auth/login
Headers:
Content-Type: application/json

Body:
{
  "email": "user@example.com"
}
   ```

CURL Example:
   ```bash
curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d '{"email":"testing@example.com"}' 'http://localhost:3000/api/v1/auth/login'
   ```
Response Body:
   ```json
{
  "data": {
    "id": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ",
    "type": "token",
    "attributes": {
      "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ"
    }
  }
}
   ```

---

## Users

### Get current user details
   ```bash
GET /api/v1/users/me
Headers:
Authorization: Bearer <JWT_TOKEN>
   ```

CURL Example:
   ```bash
curl -X GET --header 'Accept: application/json' --header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ' 'http://localhost:3000/api/v1/users/me'
   ```
Response Body:
   ```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "email": "testing@example.com",
      "balance": "0.0"
    }
  }
}
   ```

---

### Get user by ID
   ```bash
GET /api/v1/users/{id}
Headers:
Authorization: Bearer <JWT_TOKEN>
   ```

CURL Example:
   ```bash
curl -X GET --header 'Accept: application/json' --header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ' 'http://localhost:3000/api/v1/users/1'
   ```
Response Body:
   ```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "email": "testing@example.com",
      "balance": "0.0"
    }
  }
}
   ```

---

### Modify user balance
   ```bash
PATCH /api/v1/users/{id}/balance
Headers:
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

Body:
{
"amount": 100.0
}
   ```

CURL Example:
   ```bash
curl -X PATCH \
  --header "Content-Type: application/json" \
  --header "Accept: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ" \
  -d '{"amount": 20}' \
  'http://localhost:3000/api/v1/users/1/balance'
   ```
Response Body:
   ```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "email": "testing@example.com",
      "balance": "20.0"
    }
  }
}
   ```

---

### Transfer balance to another user
   ```bash
PATCH /api/v1/users/{id}/transfer_balance
Headers:
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

Body:
{
"recipient_id": 2,
"amount": 50.0
}
   ```

CURL Example:
   ```bash
curl -X PATCH \
  --header "Content-Type: application/json" \
  --header "Accept: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ" \
  -d '{"recipient_id": 2, "amount": 5}' \
  'http://localhost:3000/api/v1/users/1/transfer_balance'
   ```
Response Body:
   ```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "email": "testing@example.com",
      "balance": "15.0"
    }
  }
}
   ```