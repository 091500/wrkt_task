class UpdateUserBalance
  include Interactor

  def call
    user = context.user
    amount = context.amount

    unless user
      context.fail!(error: "User not found", error_code: 404)
    end

    begin
      amount = BigDecimal(amount)
    rescue ArgumentError, TypeError
      context.fail!(error: "Invalid amount", error_code: 422)
    end

    if amount == 0
      context.fail!(error: "Amount must be non-zero", error_code: 422)
    end

    new_balance = user.balance + amount

    if new_balance < 0
      context.fail!(error: "Insufficient funds", error_code: 422)
    end

    if amount > 0
      FinanceTransaction.create!(recipient: context.user, amount: amount.abs, transaction_type: 'deposit')
    else
      FinanceTransaction.create!(sender: context.user, amount: amount.abs, transaction_type: 'withdrawal')
    end

    context.user = user.reload
  end
end
