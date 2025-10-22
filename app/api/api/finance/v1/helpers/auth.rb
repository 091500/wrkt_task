module API
  module Finance
    module V1
      module Helpers
        module Auth
          def current_user
            header = headers["Authorization"]
            token = header.split(" ").last if header
            decoded = JsonWebToken.decode(token)
            User.find(decoded[:user_id]) if decoded
          rescue
            error!({ errors: [ error_detail ] }, 401)
          end

          def authenticate!
            error!({ errors: [ error_detail ] }, 401) unless current_user
          end

          def error_detail
            { detail: "Unauthorized" }
          end
        end
      end
    end
  end
end
