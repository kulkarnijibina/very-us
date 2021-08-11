class AddReasoneToRelationship < ActiveRecord::Migration[5.2]
  def change
    add_column :relationships, :reason, :string
  end
end
