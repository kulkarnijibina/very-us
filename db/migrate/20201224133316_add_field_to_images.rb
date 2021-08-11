class AddFieldToImages < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :is_profile_pic, :boolean, default: false
  end
end
