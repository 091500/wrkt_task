class ValidateTransferBalance
  include Interactor

  def call
    user = context.user
    recipient = context.recipient
    amount = context.amount

    unless user
      context.fail!(error: "User not found", error_code: 404)
    end

    unless recipient
      context.fail!(error: "Recipient not found", error_code: 404)
    end

    if user.id == recipient.id
      context.fail!(error: "Cannot transfer to self", error_code: 422)
    end

    begin
      amount = BigDecimal(amount)
    rescue ArgumentError, TypeError
      context.fail!(error: "Invalid amount", error_code: 422)
    end

    if amount <= 0
      context.fail!(error: "Transfer amount must be greater than zero", error_code: 422)
    end

    if user.balance < amount
      context.fail!(error: "Insufficient funds", error_code: 422)
    end
  end
end
