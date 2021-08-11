class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :payment, foreign_key: true
      t.string :description
      t.string :user_remark
      t.string :txn_id
      t.integer :status
      t.decimal :amount
      t.references :wallet, foreign_key: true

      t.timestamps
    end
  end
end
