class TransferUserBalanceOrganizer
  include Interactor::Organizer

  organize FindRecipient, TransferUserBalance
end
