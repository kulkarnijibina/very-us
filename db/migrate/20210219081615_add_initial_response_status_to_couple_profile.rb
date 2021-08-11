class AddInitialResponseStatusToCoupleProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_profiles, :initial_response_status, :boolean, default: false
    add_column :earn_ons, :reward_points_to_karma_score, :decimal
  end
end
