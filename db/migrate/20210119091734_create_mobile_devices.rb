class CreateMobileDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :mobile_devices do |t|
      t.references :user, foreign_key: true
      t.string :device_id

      t.timestamps
    end
  end
end
