class AuthenticateUser
  include Interactor

  def call
    user = User.find_by(email: context.user.email)

    if user
      context.token = JsonWebToken.encode(user_id: user.id)
    else
      context.fail!(error: "Invalid credentials", error_code: 401)
    end
  end
end
