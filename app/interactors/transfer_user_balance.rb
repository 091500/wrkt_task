class TransferUserBalance
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
      context.fail!(error: "Cannot transfer to self", error_code: 402)
    end

    if amount.to_d <= 0
      context.fail!(error: "Transfer amount must be greater than zero")
    end

    if user.balance < amount
      context.fail!(error: "Insufficient funds", error_code: 422)
    end

    ActiveRecord::Base.transaction do
      user.update!(balance: user.balance - amount)
      recipient.update!(balance: recipient.balance + amount)
    end

    context.user = user
    context.recipient = recipient

    APILogger.info("[transfer balance][user #{user.id} → #{recipient.id}}] amount: #{amount}")
  rescue ActiveRecord::RecordInvalid => e
    context.fail!(error: e.message)
  end
end
