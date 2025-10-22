class FindUser
  include Interactor

  def call
    user = User.find_by(id: context.user_id)

    if user
      context.user = user
    else
      context.fail!(error: "User not found", error_code: 404)
    end
  end
end
