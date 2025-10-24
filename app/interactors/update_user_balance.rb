class UpdateUserBalance
  include Interactor

  def call
    user = context.user
    amount = BigDecimal(context.amount)

    ActiveRecord::Base.transaction do
      transaction_amount = amount.to_d.abs
      if amount.positive?
        FinanceTransaction.create!(recipient: context.user, amount: transaction_amount, transaction_type: "deposit")
        user.increment!(:balance, transaction_amount)
      else
        FinanceTransaction.create!(sender: context.user, amount: transaction_amount, transaction_type: "withdrawal")
        user.decrement!(:balance, transaction_amount)
      end
    end

    context.user = user.reload
  rescue ActiveRecord::RecordInvalid => e
    context.fail!(error: e.message, error_code: 422)
  end
end
