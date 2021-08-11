class AddRefreshMatchesCountToBurnOn < ActiveRecord::Migration[5.2]
  def change
    add_column :burn_ons, :refresh_matches_count, :integer
    add_column :burn_ons, :spotlight_duration_in_mins, :integer
    add_column :burn_ons, :incognito_duration_in_mins, :integer
  end
end
