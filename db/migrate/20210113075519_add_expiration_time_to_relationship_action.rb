class AddExpirationTimeToRelationshipAction < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :action_expiration, :datetime
  end
end
