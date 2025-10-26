class UpdateUserBalance
  include Interactor

  class ValidationError < StandardError; end
  class NotFoundError < StandardError; end

  attr_reader :user, :amount

  def call
    ActiveRecord::Base.transaction do
      validate!
      user.lock!
      create_transaction(user, transaction_amount, amount.positive?)
      update_user_balance(user, transaction_amount, amount.positive?)
    end

    context.user = user.reload
  rescue ActiveRecord::RecordInvalid, ValidationError => e
    context.fail!(error: e.message, error_code: 422)
  rescue NotFoundError => e
    context.fail!(error: e.message, error_code: 404)
  end

  private

  def user
    @user ||= context.user
  end

  def amount
    @amount ||= BigDecimal(context.amount)
  rescue ArgumentError, TypeError
    raise ValidationError, "Invalid amount"
  end

  def transaction_amount
    @transaction_amount ||= amount.abs
  end

  def validate!
    validate_user
    validate_amount
    validate_balance
  end

  def validate_user
    unless user
      raise NotFoundError, "User not found"
    end
  end

  def validate_amount
    raise ValidationError, "Amount must be non-zero" if amount.zero?
  end

  def validate_balance
    new_balance = user.balance + amount

    if new_balance < 0
      raise ValidationError, "Insufficient funds"
    end
  end

  def create_transaction(user, amount, is_deposit)
    FinanceTransaction.create!(
      (is_deposit ? { recipient: user } : { sender: user }).merge(
        amount: amount,
        transaction_type: is_deposit ? "deposit" : "withdrawal"
      )
    )
  end

  def update_user_balance(user, amount, is_deposit)
    is_deposit ? user.increment!(:balance, amount) : user.decrement!(:balance, amount)
  end
end
