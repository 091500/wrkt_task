class TransferBalanceOrganizer
  include Interactor::Organizer

  organize FindRecipient, ValidateTransferBalance, TransferBalance
end
