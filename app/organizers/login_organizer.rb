class LoginOrganizer
  include Interactor::Organizer

  organize LoginUser, AuthenticateUser
end
