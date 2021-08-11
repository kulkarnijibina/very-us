class AddFreePerSaveForLaterOnBurnOn < ActiveRecord::Migration[5.2]
  def change
  	add_column :burn_ons, :daily_free_per_save_for_later, :integer
  end
end
