class FinanceTransaction < ApplicationRecord
  belongs_to :sender, class_name: "User", optional: true
  belongs_to :recipient, class_name: "User", optional: true

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true
  validates :transaction_type, inclusion: { in: [ "deposit", "withdrawal", "transfer" ] }
end
