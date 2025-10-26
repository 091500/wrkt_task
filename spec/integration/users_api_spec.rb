require 'swagger_helper'

describe 'API::V1::Users', type: :request do
  let(:email) { 'user@example.com' }
  let(:user) { create(:user, email: email, balance: 100) }
  let(:recipient) { create(:user, email: "recipient@email.com", balance: 0) }
  let(:token) do
    post "/api/v1/login", params: { email: email }
    JSON.parse(response.body)['data']['attributes']['token']
  end
  let(:Authorization) { "Bearer #{token}" }
  let(:amount) { { amount: 100 } }

  path '/api/v1/me' do
    get 'Retrieves current user details' do
      tags 'Users'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string, required: true, description: 'Bearer token'

      response '200', 'user found' do
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
                    balance: { type: :string }
                  }
                }
              }
            }
          }

        before do
          user
        end

        run_test!
      end

      response '401', 'unauthorized' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }
        let(:Authorization) { "Bearer something" }

        run_test!
      end
    end
  end

  path '/api/v1/update_balance' do
    patch 'Updates user balance' do
      tags 'Users'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :amount, in: :body, schema: {
        type: :object,
        properties: {
          amount: { type: :number }
        },
        required: [ 'amount' ]
      }


      response '200', 'balance updated' do
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
                    balance: { type: :string }
                  }
                }
              }
            }
          }

        before do
          user
        end

        run_test!
      end

      response '422', 'invalid amount or insufficient funds' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        let(:amount) { { amount: "sdf" } }

        before do
          user
        end

        run_test!
      end
    end
  end

  path '/api/v1/transfer_balance' do
    patch 'Transfers balance to another user' do
      tags 'Users'
      security [ bearer_auth: [] ]
      consumes 'application/json'
      produces 'application/json'
      parameter name: :transfer, in: :body, schema: {
        type: :object,
        properties: {
          recipient_id: { type: :integer },
          amount: { type: :number }
        },
        required: [ 'recipient_id', 'amount' ]
      }

      response '200', 'transfer successful' do
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
                    balance: { type: :string }
                  }
                }
              }
            }
          }

        before do
          user
          recipient
        end

        let(:transfer) { { recipient_id: recipient.id, amount: 20 } }

        run_test!
      end

      response '422', 'invalid amount or insufficient funds' do
        schema type: :object,
          properties: {
            error: { type: :string }
          }

        before do
          user
          recipient
        end

        let(:transfer) { { recipient_id: recipient.id, amount: 120 } }

        run_test!
      end
    end
  end
end
