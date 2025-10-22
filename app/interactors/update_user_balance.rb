class UpdateUserBalance
  include Interactor

  def call
    user = context.user
    amount = context.amount

    unless user
      context.fail!(error: "User not found", error_code: 404)
    end

    unless amount.is_a?(Numeric)
      context.fail!(error: "Invalid amount", error_code: 400)
    end

    new_balance = user.balance + amount

    if new_balance < 0
      context.fail!(error: "Insufficient funds", error_code: 422)
    end

    user.update!(balance: new_balance)
    context.user = user

    APILogger.info("[update balance][user #{user.id}] amount: #{amount}, new balance: #{user.balance}")
  end
end
