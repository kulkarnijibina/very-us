class RemoveForeignKeyToCoupleProfile < ActiveRecord::Migration[5.2]
  def change
  	remove_foreign_key :couple_profiles, column: :profile_pic_id
  end
end
