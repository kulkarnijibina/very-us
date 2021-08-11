class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.boolean :is_read, default: false
      t.string  :notification_text
      t.bigint  :notificationable_id
      t.string  :notificationable_type

      t.timestamps
    end
  end
end
