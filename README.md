# Rails API Application

This is a Ruby on Rails **8.0.3** application built as a **JSON API backend**.  
All API responses follow the [JSON:API](https://jsonapi.org/) specification and are secured using **JWT** tokens.
Business logic is organized using the [Interactor](https://github.com/collectiveidea/interactor) gem.

The application includes endpoints for user registration, authentication, balance management, and balance transfer between users.
To use the API, clients must first register or log in to receive a JWT token, which is then used for authenticated requests.
Users can modify their balance and transfer funds to other users, with all operations validated to ensure data integrity.

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
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:test:prepare
```

## Running the Application

Start the Rails server:

```bash
bin/rails server
```
By default, the API will be available at:
http://localhost:3000

## API

- The OpenAPI / Swagger documentation is located at:

http://localhost:3000/api-docs

Responses follow the JSON:API format.
Following requests are do not require authentication:
- `POST /api/v1/register` - Register a new user and receive a JWT token
- `POST /api/v1/login` - Login and receive a JWT token

Following requests are authenticated using JWT tokens:
- `GET /api/v1/me` - Get current user details
- `PATCH /api/v1/update_balance` - Modify user balance
- `PATCH /api/v1/transfer_balance` - Transfer balance to another user

## Models
- **Token:** Represents JWT tokens for authentication (not persisted in the database).
- **User:** Represents a user in the system with attributes like email and balance.
- **Transaction:** Represents balance modification and transfer transactions between users.

## Running Tests

Run the test suite with:
```bash
bundle exec rspec
```

Code coverage reports will be generated in the `coverage/` directory.

## Code Quality

Run RuboCop to check for linting and style issues:
```bash
bundle exec rubocop
``` 

## Generate API Documentation
```bash
bundle exec rake rswag:specs:swaggerize
``` 

## Brakeman Security Analysis
```bash
bundle exec brakeman
``` 

## Project Structure
```bash
app/
├── app/controllers/api/   # API Controllers
├── models/                # ActiveRecord models
├── serializers/           # JSONAPI serializers
├── interactors/           # Business logic using Interactor gem
├── lib/                   # Custom modules and utilities
├── spec/                  # RSpec tests
├── spec/integration/      # Integration tests for API endpoints
├── config/                # App configuration files
├── swagger/               # Swagger/OpenAPI documentation files
``` 

## Using the API

## Auth

### Register a new user
```bash
POST /api/v1/register
Content-Type: application/json

Body:
{
"email": "user@example.com"
}
```

CURL Example:
```bash
curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d '{"email":"testing@example.com"}' 'http://localhost:3000/api/v1/register'
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
POST /api/v1/login
Headers:
Content-Type: application/json

Body:
{
  "email": "user@example.com"
}
```

CURL Example:
```bash
curl -X POST -H "Content-Type: application/json" -H "Accept: application/json" -d '{"email":"testing@example.com"}' 'http://localhost:3000/api/v1/login'
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
GET /api/v1/me
Headers:
Authorization: Bearer <JWT_TOKEN>
```

CURL Example:
```bash
curl -X GET --header 'Accept: application/json' --header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ' 'http://localhost:3000/api/v1/me'
```
Response Body:
```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "balance": "0.0"
    }
  }
}
```

### Modify user balance

It is possible to use positive and negative amounts for balance modification.
User balance is not allowed to go below zero.

```bash
PATCH /api/v1/update_balance
Headers:
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

Body:
{
"amount": 100.0
}
```

CURL Example (add 20 to balance):
```bash
curl -X PATCH \
  --header "Content-Type: application/json" \
  --header "Accept: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ" \
  -d '{"amount": 20}' \
  'http://localhost:3000/api/v1/update_balance'
```
Response Body:
```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "balance": "20.0"
    }
  }
}
```

---

CURL Example (subtract 10 from balance):
```bash
curl -X PATCH \
  --header "Content-Type: application/json" \
  --header "Accept: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ" \
  -d '{"amount": -10}' \
  'http://localhost:3000/api/v1/update_balance'
```
Response Body:
```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "balance": "10.0"
    }
  }
}
```

---

### Transfer balance to another user

It is possible to user positive and negative amounts for transfer.
User balance is not allowed to go below zero.

```bash
PATCH /api/v1/transfer_balance
Headers:
Authorization: Bearer <JWT_TOKEN>
Content-Type: application/json

Body:
{
"recipient_id": 2,
"amount": 50.0
}
```

CURL Example (transfer 5 to user with ID 2):
```bash
curl -X PATCH \
  --header "Content-Type: application/json" \
  --header "Accept: application/json" \
  --header "Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3NjEyMTQ4NDJ9.u6E333kykHNPpRRyKREXT7CvWG4H8gi5Qi1qQvYJHuQ" \
  -d '{"recipient_id": 2, "amount": 5}' \
  'http://localhost:3000/api/v1/transfer_balance'
```
Response Body:
```json
{
  "data": {
    "id": "1",
    "type": "user",
    "attributes": {
      "balance": "15.0"
    }
  }
}
```
