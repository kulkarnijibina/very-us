class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.references :couple_profile, foreign_key: true
      t.references :currency, foreign_key: true

      t.timestamps
    end
  end
end
