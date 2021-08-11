class CreateCoupleChats < ActiveRecord::Migration[5.2]
  def change
    create_table :couple_chats do |t|
      t.bigint :couple_profile_id
      t.bigint :chat_id
    end
  end
end
