class AddPlaceFieldToCoupleProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_profiles, :place, :string
  end
end
