class CreateMeetups < ActiveRecord::Migration[5.2]
  def change
    create_table :meetups do |t|
      t.integer :source_couple_id
      t.integer :target_couple_id
      t.integer :status
      t.datetime :date_time
      t.string :location
      t.string :description

      t.timestamps
    end
  end
end
