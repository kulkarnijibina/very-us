class AddReferencesProfilePicIdToCoupleProfile < ActiveRecord::Migration[5.2]
  def change
  	add_column :couple_profiles, :profile_pic_id, :integer, index: true
    add_foreign_key :couple_profiles, :images, column: :profile_pic_id
  end
end
