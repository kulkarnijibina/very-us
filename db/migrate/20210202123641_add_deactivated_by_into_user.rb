class AddDeactivatedByIntoUser < ActiveRecord::Migration[5.2]
  def change
  	remove_column :couple_profiles, :deactivated
    add_column :couple_profiles, :status, :string, default: "active"
  end
end
