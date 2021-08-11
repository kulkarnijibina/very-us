class AddIsCoupleSameToMeetupFeedback < ActiveRecord::Migration[5.2]
  def change
    add_column :meetup_feedbacks, :is_couple_same, :boolean
    add_column :meetup_feedbacks, :meet_again, :boolean
    add_column :meetup_feedbacks, :couple_behaviour, :boolean
    add_column :meetup_feedbacks, :couple_badge, :string
    remove_column :meetup_feedbacks, :points, :integer
    remove_column :meetup_feedbacks, :description, :string
  end
end
