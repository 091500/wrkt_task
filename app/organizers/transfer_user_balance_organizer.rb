class TransferUserBalanceOrganizer
  include Interactor::Organizer

  organize FindUser, FindRecipient, TransferUserBalance
end
