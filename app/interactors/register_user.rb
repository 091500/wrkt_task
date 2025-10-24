class RegisterUser
  include Interactor

  def call
    user = User.new(email: context.email)

    if user.save
      context.token = JsonWebToken.encode(user_id: user.id)
    else
      context.fail!(error: user.errors.full_messages.join(", "), error_code: 422)
    end
  end
end
