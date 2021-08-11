class AddFreeSaveForLaterCountOnCoupleProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_profiles, :free_save_for_later_count, :integer, default: BurnOn.configuration.daily_free_per_save_for_later
  end
end
