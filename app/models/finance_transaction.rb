class FinanceTransaction < ApplicationRecord
  belongs_to :sender, class_name: "User", optional: true
  belongs_to :recipient, class_name: "User", optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true
  validates :transaction_type, inclusion: { in: [ "deposit", "withdrawal", "transfer" ] }

  after_create :apply_transaction

  private

  def apply_transaction
    case transaction_type
    when "deposit"
      recipient.increment!(:balance, amount)
    when "withdrawal"
      sender.decrement!(:balance, amount)
    when "transfer"
      sender.decrement!(:balance, amount)
      recipient.increment!(:balance, amount)
    end
  end
end
