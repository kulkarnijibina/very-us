class CreateSpendFreeTimeIcons < ActiveRecord::Migration[5.2]
  def change
    create_table :spend_free_time_icons do |t|
      t.string :name
      
      t.timestamps
    end
  end
end
