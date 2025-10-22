module API
  module Finance
    module V1
      class Users < Grape::API
        include Helpers::Description

        resource :users do
          before { authenticate! }

          desc "Get current user details",
            headers: AUTH_HEADERS,
            success: {
              code: 200,
              message: "User data returned successfully"
            },
            failure: [
              UNAUTHORIZED_RESPONSE
            ]

          get :me do
            jsonapi_response(current_user, UserSerializer)
          end

          desc "Get user by ID",
            headers: Helpers::Description::AUTH_HEADERS,
            params: {
              id: { type: Integer, desc: "User ID" }
            },
            success: { code: 200, message: "OK" },
            failure: [
              Helpers::Description::UNAUTHORIZED_RESPONSE,
              Helpers::Description::USER_NOT_FOUND_RESPONSE
            ]

          route_param :id, type: Integer do
            get do
              result = FindUser.call(user_id: params[:id])

              if result.success?
                jsonapi_response(result.user, UserSerializer)
              else
                error_response!(result)
              end
            end
          end

          route_param :id, type: Integer do
            params do
              requires :amount, type: BigDecimal, desc: "Amount to add (positive) or reduce (negative)"
            end

            desc "Modify user balance",
              headers: Helpers::Description::AUTH_HEADERS,
              params: {
                amount: { type: BigDecimal, desc: "Amount to add (positive) or reduce (negative)" }
              },
              success: { code: 200, message: "OK" },
              failure: [
                UNAUTHORIZED_RESPONSE,
                USER_NOT_FOUND_RESPONSE,
                { code: 400, message: "Invalid amount" },
                { code: 422, message: "Insufficient funds" }
              ]

            patch :balance do
              result = UpdateUserBalanceOrganizer.call(user_id: params[:id], amount: params[:amount].to_d)

              if result.success?
                jsonapi_response(result.user, UserSerializer)
              else
                error_response!(result)
              end
            end
          end

          route_param :id, type: Integer do
            params do
              requires :recipient_id, type: Integer, desc: "Recipient user ID"
              requires :amount, type: BigDecimal, desc: "Amount to transfer"
            end

            desc "Transfer balance to another user",
              headers: Helpers::Description::AUTH_HEADERS,
              params: {
                recipient_id: { type: Integer, desc: "Recipient user ID" },
                amount: { type: BigDecimal, desc: "Amount to transfer" }
              },
              success: { code: 200, message: "OK" },
              failure: [
                Helpers::Description::UNAUTHORIZED_RESPONSE,
                Helpers::Description::USER_NOT_FOUND_RESPONSE,
                { code: 400, message: "Transfer amount must be greater than zero" },
                { code: 402, message: "Cannot transfer to self" },
                { code: 405, message: "Recipient not found" },
                { code: 422, message: "Insufficient funds" }
              ]

            patch :transfer_balance do
              result = TransferUserBalanceOrganizer.call(
                user_id: params[:id],
                recipient_id: params[:recipient_id],
                amount: params[:amount]
              )

              if result.success?
                jsonapi_response(result.user, UserSerializer)
              else
                error_response!(result)
              end
            end
          end
        end
      end
    end
  end
end
