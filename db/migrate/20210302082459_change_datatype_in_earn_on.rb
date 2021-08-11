class ChangeDatatypeInEarnOn < ActiveRecord::Migration[5.2]
  def change
    change_column :balance_logs, :balance, :integer
    change_column :burn_ons, :refresh_match_list, :integer
    change_column :burn_ons, :per_save_for_later, :integer
    change_column :burn_ons, :change_preference, :integer
    change_column :burn_ons, :change_geography, :integer
    change_column :burn_ons, :incognito_mode, :integer
    change_column :burn_ons, :spotlight_focus, :integer
    change_column :burn_ons, :edit_tags_on_match_list, :integer
    change_column :earn_ons, :onboarding, :integer
    change_column :earn_ons, :partner_app_download, :integer
    change_column :earn_ons, :per_accept_chat, :integer
    change_column :earn_ons, :initial_response, :integer
    change_column :earn_ons, :media_posts_per_photo, :integer
    change_column :earn_ons, :verification_status, :integer
    change_column :earn_ons, :feedback_fill_per_couple_meet, :integer
    change_column :earn_ons, :reward_points_to_karma_score, :integer
    change_column :earn_ons, :profile_completed_score, :integer
    change_column :earn_ons, :social_media_connected, :integer
    change_column :transactions, :amount, :integer
  end
end