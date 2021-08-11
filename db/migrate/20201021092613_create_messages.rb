class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :couple_profile, foreign_key: true
      t.references :chat, foreign_key: true

      t.timestamps
    end
  end
end
