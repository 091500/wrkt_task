module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
    attr_reader :current_user
  end

  private

  def authenticate_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header.present?

    decoded = JsonWebToken.decode(token)
    unless decoded.present?
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
    @current_user = User.find(decoded[:user_id])
  rescue ActiveRecord::RecordNotFound, JWT::DecodeError
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
