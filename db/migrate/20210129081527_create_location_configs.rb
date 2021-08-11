class CreateLocationConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :location_configs do |t|
      t.string :default_latitude
      t.string :default_longitude
      t.integer :status

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        LocationConfig.reset_column_information
        LocationConfig.active.first_or_create
      end
    end
  end
end
