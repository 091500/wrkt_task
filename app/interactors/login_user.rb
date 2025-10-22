class LoginUser
  include Interactor

  def call
    user = User.find_by(email: context.email)

    if user
      context.user = user
    else
      context.fail!(error: "User not found")
    end
  end
end
