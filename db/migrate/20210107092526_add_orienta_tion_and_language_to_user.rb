class AddOrientaTionAndLanguageToUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :language_id
    add_column :users, :language, :string
    add_column :users, :orientation, :string
    add_column :couple_profiles, :secondary_user_details, :jsonb, default: {}
  end
end
