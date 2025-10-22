module API
  module Finance
    module V1
      module Helpers
        module Description
          UNAUTHORIZED_RESPONSE = { code: 401, message: "Unauthorized" }.freeze
          USER_NOT_FOUND_RESPONSE = { code: 404, message: "User Not Found" }.freeze
          AUTH_HEADERS = {
            "Authorization" => {
              description: "JWT Token. Example: Bearer eyJhbGciOiJIUzI1NiIs...",
              required: true
            }
          }.freeze
          EMAIL_PARAMS = { type: String, desc: "User email", required: true }.freeze
        end
      end
    end
  end
end
