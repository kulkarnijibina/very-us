class AddAndRemoveAttributesFromUser < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :drink_or_smoke
    add_column :users, :smoke, :string
    add_column :users, :drink, :string
    add_column :users, :occupation, :string
  end
end
