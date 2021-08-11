class RemoveProfilePicFromCoupleProfile < ActiveRecord::Migration[5.2]
  def change
    remove_column :couple_profiles, :profile_pic_id
  end
end
