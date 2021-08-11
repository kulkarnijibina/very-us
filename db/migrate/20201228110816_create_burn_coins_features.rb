class CreateBurnCoinsFeatures < ActiveRecord::Migration[5.2]
  def change
    create_table :burn_coins_features do |t|
      t.string :name
      t.string :description
      t.integer :coins

      t.timestamps
    end
  end
end
