class ChangeColumnInLocations < ActiveRecord::Migration[5.2]
  def up
    change_column :locations, :latitude, :string
  end
end
