class CreateEarnOns < ActiveRecord::Migration[5.2]
  def change
    create_table :earn_ons do |t|
      t.decimal :onboarding
      t.decimal :partner_app_download
      t.decimal :per_accept_chat
      t.decimal :initial_response
      t.decimal :media_posts_per_photo
      t.decimal :verification_status
      t.decimal :feedback_fill_per_couple_meet
      t.integer :status

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        EarnOn.reset_column_information
        EarnOn.active.first_or_create
      end
    end
  end
end
