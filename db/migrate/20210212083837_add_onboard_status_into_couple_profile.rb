class AddOnboardStatusIntoCoupleProfile < ActiveRecord::Migration[5.2]
  def change
  	add_column :couple_profiles, :onboarding_status, :string
  end
end
