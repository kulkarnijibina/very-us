class CreateMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :matches do |t|
      t.integer :target_couple_id
      t.integer :source_couple_id
      t.references :bucket, foreign_key: true
      t.float :percentage

      t.timestamps
    end
  end
end
