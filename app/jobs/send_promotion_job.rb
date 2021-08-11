class SendPromotionJob < ApplicationJob
  queue_as :default

  def perform(title, notification_message)
    CoupleProfile.active.each do |couple_profile|
      data_hash = {notificationable_id: couple_profile.id , notificationable_type: 'promotion'}
      PushNotification.trigger_notification(couple_profile.primary_user, data_hash, title, notification_message)
      PushNotification.trigger_notification(couple_profile.secondary_user, data_hash, title, notification_message) if couple_profile.secondary_user
    end
  end
end
