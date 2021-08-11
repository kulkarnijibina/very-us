class AddIsDeletedToChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :is_deleted, :boolean, :default=> false
  end
end
