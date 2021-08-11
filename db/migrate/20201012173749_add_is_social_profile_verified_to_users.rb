class AddIsSocialProfileVerifiedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :linkedin_verified, :boolean, default: false
    add_column :users, :facebook_verified, :boolean, default: false
    add_column :users, :instagram_verified, :boolean, default: false
  end
end
