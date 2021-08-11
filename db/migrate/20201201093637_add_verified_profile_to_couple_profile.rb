class AddVerifiedProfileToCoupleProfile < ActiveRecord::Migration[5.2]
  def change
  	add_column :couple_profiles, :verified_profile, :boolean, default: false
  end
end
