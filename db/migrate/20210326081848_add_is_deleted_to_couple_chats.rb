class AddIsDeletedToCoupleChats < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_chats, :is_deleted, :boolean
  end
end
