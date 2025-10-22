module API
  module Finance
    module V1
      class Auth < Grape::API
        include Helpers::Description

        helpers do
          params :email do
            requires :email, type: String, regexp: URI::MailTo::EMAIL_REGEXP
          end
        end

        resource :auth do
          desc "User Registration",
            params: {
              email: EMAIL_PARAMS
            },
            success: { code: 201, message: "User registered successfully" },
            failure: [
              { code: 400, message: "Email missing or invalid" }
            ]

          params do
            use :email
          end

          post :register do
            result = RegisterOrganizer.call(email: params[:email])

            if result.success?
              jsonapi_response(OpenStruct.new(token: result.token), AuthTokenSerializer)
            else
              error_response!(result)
            end
          end

          desc "Login",
            params: {
              email: EMAIL_PARAMS
            },
            success: { code: 201, message: "Login successful" },
            failure: [
              { code: 401, message: "Invalid credentials" }
            ]

          params do
            use :email
          end

          post :login do
            result = LoginOrganizer.call(email: params[:email])

            if result.success?
              jsonapi_response(OpenStruct.new(token: result.token), AuthTokenSerializer)
            else
              error_response!(result, 401)
            end
          end
        end
      end
    end
  end
end
