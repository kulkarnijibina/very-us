class AddClearChatInChatCouple < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_chats, :clear_chat, :datetime
  end
end
