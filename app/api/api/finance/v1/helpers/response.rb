module API
  module Finance
    module V1
      module Helpers
        module Response
          def jsonapi_response(resource, serializer)
            serializer.new(resource).serializable_hash
          end

          def error_response!(context, error_code = 400)
            error_detail = context[:error] || "An error occurred"
            response_status = context[:error_code] || error_code
            error!({ errors: [ { detail: error_detail } ] }, response_status)
          end
        end
      end
    end
  end
end
