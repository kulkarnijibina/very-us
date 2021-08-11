class AddChatInactivityThresholdToApplicationConfigs < ActiveRecord::Migration[5.2]
  def change
    add_column :application_configs, :chat_inactivity_threshold_in_days, :integer
  end
end
