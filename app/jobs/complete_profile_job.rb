class CompleteProfileJob < ApplicationJob
  queue_as :default

  def perform(couple_profile)
    unless couple_profile.profile_completed
      title = couple_profile.name
      notification_message = "Complete your profile"
      data_hash = {notificationable_id: couple_profile.id , notificationable_type: 'complete_your_profile'}
      PushNotification.trigger_notification(couple_profile.primary_user, data_hash, title, notification_message)
    end
  end
end
