class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.references :couple_profile, foreign_key: true

      t.timestamps
    end
  end
end
