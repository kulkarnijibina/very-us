class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.decimal :latitude
      t.string :longitude
      t.bigint  :locationable_id
      t.string  :locationable_type

      t.timestamps
    end

    add_index :locations, [:locationable_id, :locationable_type]
  end
end
