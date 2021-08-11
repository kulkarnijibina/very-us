class AddTransactionTypeToTransaction < ActiveRecord::Migration[5.2]
  def change
  	add_column :transactions, :transaction_type, :string
  	add_column :transactions, :transaction_purpose, :string
  end
end
