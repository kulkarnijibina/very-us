class AddSpotlightOnToCoupleProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_profiles, :spotlight_on, :boolean, default: false
    add_column :couple_profiles, :incognito, :boolean, default: false
  end
end
