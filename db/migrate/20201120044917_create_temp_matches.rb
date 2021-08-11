class CreateTempMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :temp_matches do |t|
      t.integer :source_couple_id
      t.integer :target_couple_id
      t.float :percentage

      t.timestamps
    end
  end
end
