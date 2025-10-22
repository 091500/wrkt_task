module API
  module Finance
    module V1
      class Base < Grape::API
        version "v1", using: :path
        helpers Helpers::Auth, Helpers::Response
        mount Auth
        mount Users
      end
    end
  end
end
