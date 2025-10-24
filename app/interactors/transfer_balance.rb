class TransferBalance
  include Interactor

  def call
    user = context.user
    recipient = context.recipient
    amount = BigDecimal(context.amount)

    ActiveRecord::Base.transaction do
      transaction_amount = amount.abs
      FinanceTransaction.create!(sender: user, recipient: recipient, amount: transaction_amount, transaction_type: "transfer")
      user.decrement!(:balance, transaction_amount)
      recipient.increment!(:balance, transaction_amount)
    end

    context.user = user.reload
    context.recipient = recipient.reload
  rescue ActiveRecord::RecordInvalid => e
    context.fail!(error: e.message, error_code: 422)
  end
end
