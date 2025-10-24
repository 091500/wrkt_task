class API::V1::AuthController < ActionController::API
  include ApplicationHelper

  def register
    result = RegisterUser.call(email: params[:email])

    if result.success?
      jsonapi_response(OpenStruct.new(token: result.token), AuthTokenSerializer)
    else
      error_response(result)
    end
  end

  def login
    result = LoginUser.call(email: params[:email])

    if result.success?
      jsonapi_response(OpenStruct.new(token: result.token), AuthTokenSerializer)
    else
      error_response(result, :unauthorized)
    end
  end
end
