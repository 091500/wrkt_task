class TransferBalance
  include Interactor

  class ValidationError < StandardError; end
  class NotFoundError < StandardError; end

  attr_reader :amount, :user, :recipient

  def call
    ActiveRecord::Base.transaction do
      validate!
      user.lock!
      recipient.lock!
      create_transaction
      update_balances
    end

    context.user = user.reload
    context.recipient = recipient.reload
  rescue ActiveRecord::RecordInvalid, ValidationError => e
    context.fail!(error: e.message, error_code: 422)
  rescue NotFoundError => e
    context.fail!(error: e.message, error_code: 404)
  end

  private

  def amount
    @amount ||= BigDecimal(context.amount)
  rescue ArgumentError, TypeError
    raise ValidationError, "Invalid amount"
  end

  def user
    @user ||= context.user
  end

  def recipient
    @recipient ||= context.recipient
  end

  def validate!
    validate_user
    validate_recipient
    validate_amount
    validate_balance
  end

  def validate_user
    unless user
      raise NotFoundError, "User not found"
    end
  end

  def validate_recipient
    unless recipient
      raise NotFoundError, "Recipient not found"
    end

    if user.id == recipient.id
      raise ValidationError, "Cannot transfer to self"
    end
  end

  def validate_amount
    if amount <= 0
      raise ValidationError, "Transfer amount must be greater than zero"
    end
  end

  def validate_balance
    if user.balance < amount
      raise ValidationError, "Insufficient funds"
    end
  end

  def create_transaction
    FinanceTransaction.create!(sender: user, recipient: recipient, amount: amount, transaction_type: "transfer")
  end

  def update_balances
    user.decrement!(:balance, amount)
    recipient.increment!(:balance, amount)
  end
end
