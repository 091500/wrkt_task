class RegisterOrganizer
  include Interactor::Organizer

  organize RegisterUser, AuthenticateUser
end
