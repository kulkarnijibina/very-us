class AddEarnonRecordsToCoupleProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :couple_profiles, :earnon_records, :jsonb, default: {}
    add_column :earn_ons, :profile_completed_score, :decimal
    add_column :earn_ons, :social_media_connected, :decimal
  end
end
