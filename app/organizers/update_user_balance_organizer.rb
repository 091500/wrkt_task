class UpdateUserBalanceOrganizer
  include Interactor::Organizer

  organize ValidateUserBalance, UpdateUserBalance
end
