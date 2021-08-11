class CreateRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :relationships do |t|
      t.integer :source_couple_id
      t.integer :target_couple_id
      t.string :action

      t.timestamps
    end
  end
end
