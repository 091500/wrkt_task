module API
  class Root < Grape::API
    prefix "api"
    format :json
    default_format :json

    mount API::Finance::V1::Base

    add_swagger_documentation(
      mount_path: "/swagger_doc",
      hide_documentation_path: true
    )
  end
end
