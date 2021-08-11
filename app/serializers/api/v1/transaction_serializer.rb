class Api::V1::TransactionSerializer < ActiveModel::Serializer
  attributes :id, :amount, :payment_id, :description, :status, :wallet_id, :transaction_type, :transaction_purpose, :balance, :created_at, :updated_at

  def balance
    object.balance_log.balance
  end

end
