class AddPerSaveForLaterExpirationTimeOnBurnOn < ActiveRecord::Migration[5.2]
  def change
  	add_column :burn_ons, :per_save_for_later_duration_in_days, :integer
  end
end
