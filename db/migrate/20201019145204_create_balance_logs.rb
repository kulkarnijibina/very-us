class CreateBalanceLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :balance_logs do |t|
      t.references :transaction, foreign_key: true
      t.references :wallet, foreign_key: true
      t.decimal :balance

      t.timestamps
    end
  end
end
