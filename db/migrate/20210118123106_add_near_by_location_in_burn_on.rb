class AddNearByLocationInBurnOn < ActiveRecord::Migration[5.2]
  def change
    add_column :burn_ons, :near_by_location_in_km, :integer
  end
end
