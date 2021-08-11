class BalanceLog < ApplicationRecord
  attr_accessor :amount

  # belongs_to
  belongs_to :txn, class_name: 'Transaction', foreign_key: :transaction_id #cant use transaction as it is reserved keyword
  belongs_to :wallet

  # callbacks
  before_save :update_balance

  private
  def update_balance
    self.balance = self.wallet.get_balance + amount
    if amount < 0 && self.balance < 0
      errors.add(:base, "Insufficient Wallet Balance!")
      throw(:abort)
    end
  end
end
