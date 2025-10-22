class UpdateUserBalanceOrganizer
  include Interactor::Organizer

  organize FindUser, UpdateUserBalance
end
