require 'swagger_helper'

describe 'API::V1::Auth', type: :request do
  path '/api/v1/register' do
    post 'Registers a new user' do
      tags 'Auth'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :email, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string }
        },
        required: [ 'email' ]
      }

      response '200', 'user registered' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    token: { type: :string }
                  }
                }
              }
            }
          }
        let(:email) { { email: 'user@example.com' } }
        run_test!
      end

      response '422', 'invalid email' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        let(:email) { { email: 'invalid' } }
        run_test!
      end
    end
  end

  path '/api/v1/login' do
    post 'Logs in a user' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :email, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string }
        },
        required: [ 'email' ]
      }

      response '200', 'login successful' do
        schema type: :object,
          properties: {
            data: {
              type: :object,
              properties: {
                id: { type: :string },
                type: { type: :string },
                attributes: {
                  type: :object,
                  properties: {
                    token: { type: :string }
                  }
                }
              }
            }
          }

        let(:email) { { email: 'user@example.com' } }
        before { create(:user, email: 'user@example.com') }
        run_test!
      end

      response '401', 'login failed' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        let(:email) { { email: 'not_existing@example.com' } }
        run_test!
      end
    end
  end
end
