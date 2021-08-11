class AddPersonalityTraitsToCoupleProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_profiles, :personality_traits, :string, array: true, default: []
    add_column :couple_profiles, :activities, :string, array: true, default: []
  end
end
