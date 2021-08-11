class CreateCoinPackages < ActiveRecord::Migration[5.2]
  def change
    create_table :coin_packages do |t|
      t.string :title
      t.integer :amount
      t.integer :coins
      t.timestamps
    end
  end
end
