class TransferBalanceOrganizer
  include Interactor::Organizer

  organize ValidateTransferBalance, TransferBalance
end
