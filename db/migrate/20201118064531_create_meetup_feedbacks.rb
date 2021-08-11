class CreateMeetupFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :meetup_feedbacks do |t|
      t.references :meetup, foreign_key: true
      t.integer :points
      t.string :description
      t.integer :source_couple_id
      t.integer :target_couple_id

      t.timestamps
    end
  end
end
