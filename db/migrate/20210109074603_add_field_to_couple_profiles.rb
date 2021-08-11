class AddFieldToCoupleProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_profiles, :first_time_change_to_personality_trait, :boolean, default: true
  end
end
