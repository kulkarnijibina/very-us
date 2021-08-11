# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name, default: ''
      t.string :last_name, default: ''
      t.string :contact, default: ''
      t.string :otp
      t.integer :language_id
      t.timestamps
    end
  end
end
