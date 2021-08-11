class ChangeSpotlightTypeInCoupleProfile < ActiveRecord::Migration[5.2]
  def change
    remove_column :couple_profiles, :spotlight_on
    remove_column :couple_profiles, :incognito
    add_column :couple_profiles, :spotlight_on_time, :datetime
    add_column :couple_profiles, :incognito_time, :datetime
  end
end
