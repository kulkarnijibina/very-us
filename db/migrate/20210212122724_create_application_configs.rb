class CreateApplicationConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :application_configs do |t|
      t.string :admin_contact_email
      t.integer :status

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        ApplicationConfig.reset_column_information
        ApplicationConfig.active.first_or_create
      end
    end
  end
end
