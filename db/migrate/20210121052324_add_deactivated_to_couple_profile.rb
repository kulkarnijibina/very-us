class AddDeactivatedToCoupleProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_profiles, :deactivated, :boolean, default: false
  end
end
