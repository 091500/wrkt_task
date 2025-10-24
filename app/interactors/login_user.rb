class LoginUser
  include Interactor

  def call
    user = User.find_by(email: context.email)

    if user
      context.token = JsonWebToken.encode(user_id: user.id)
    else
      context.fail!(error: "User not found", error_code: 401)
    end
  end
end
