class API::V1::UsersController < ActionController::API
  include ApplicationHelper
  include Authenticatable

  def me
    jsonapi_response(current_user, UserSerializer)
  end

  def update_balance
    result = UpdateUserBalanceOrganizer.call(user: current_user, amount: params[:amount])

    if result.success?
      jsonapi_response(result.user, UserSerializer)
    else
      error_response(result)
    end
  end

  def transfer_balance
    result = TransferBalanceOrganizer.call(
      user: current_user,
      recipient_id: params[:recipient_id],
      amount: params[:amount]
    )

    if result.success?
      jsonapi_response(result.user, UserSerializer)
    else
      error_response(result)
    end
  end
end
