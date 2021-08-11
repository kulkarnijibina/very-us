namespace :send_notification_for_save_for_later do
  desc "Send notification for save for later"
  task :update => [:environment] do
    Relationship.save_for_later.where(action_expiration: DateTime.current..2.days.after.in_time_zone).each do |relationship|
      title = 'Save for later relationship near to expire.'
      message = "After #{GetTimeDifference.call(relationship.action_expiration)},The save for later will be expired for #{relationship.target_couple.name}."
      data_hash = {notificationable_id: relationship.target_couple_id, notificationable_type: 'save_for_later'}
      PushNotification.trigger_notification(relationship.source_couple.primary_user, data_hash, title, message)
      PushNotification.trigger_notification(relationship.source_couple.secondary_user, data_hash, title, message) if relationship.source_couple.secondary_user.present?
    end
  end
end