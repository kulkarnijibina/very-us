class Wallet < ApplicationRecord
  # belongs_to
  belongs_to :couple_profile
  belongs_to :currency, optional: true

  # has_many
  has_many :transactions, dependent: :destroy
  has_many :balance_logs, dependent: :destroy

  # public methods
  def credit_amount(amount, description, transaction_purpose, payment=nil)
    transactions.create(amount: amount.abs, payment: payment, transaction_type: 'credit', transaction_purpose: transaction_purpose, description: description)
  end

  def debit_amount(amount, description, transaction_purpose)
    transactions.create(amount: -amount.abs, description: description, transaction_type: 'debit', transaction_purpose: transaction_purpose)
  end

  def get_balance
    balance_logs.last&.balance || 0
  end
end
