class CreateCoupleProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :couple_profiles do |t|
      t.date :anniversary
      t.string :orientation
      t.boolean :have_children
      t.boolean :have_pets
      t.string :do_for_fun
      t.string :goals
      t.string :values_needed
      t.string :meetup_dates
      t.boolean :chat_availability
      t.integer :primary_user_id
      t.integer :secondary_user_id
      t.string :partner_number, default: ''

      t.timestamps
    end
  end
end
