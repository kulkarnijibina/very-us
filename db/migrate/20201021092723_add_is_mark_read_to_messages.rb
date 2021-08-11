class AddIsMarkReadToMessages < ActiveRecord::Migration[5.2]
  def change
    add_column :messages, :is_mark_read, :boolean, :default=> false
  end
end
