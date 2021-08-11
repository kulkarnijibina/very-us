class AddProfileCompletedToCoupleProfile < ActiveRecord::Migration[5.2]
  def change
  	add_column :couple_profiles, :profile_completed, :boolean, default: false
  end
end
