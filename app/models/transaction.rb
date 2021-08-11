class Transaction < ApplicationRecord

  enum transaction_type: { debit: 'debit', credit: 'credit' }
  delegate :couple_profile, to: :wallet
  # belongs_to
  belongs_to :payment, optional: true
  belongs_to :wallet

  # has_one
  has_one :balance_log, dependent: :destroy

  # validations
  validates :amount, :transaction_type, :transaction_purpose, presence: true

  validate :positive_balance, if: :wallet

  # callbacks
  after_create :add_balance_log

  private
  def positive_balance
    if (amount < 0) && (wallet.get_balance + amount < 0)
      errors.add(:base, "Insufficient Wallet Balance!")
    end
  end

  def add_balance_log
    create_balance_log!(amount: amount, wallet: wallet)
  end
end
