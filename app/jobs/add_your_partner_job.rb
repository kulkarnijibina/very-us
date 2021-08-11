class AddYourPartnerJob < ApplicationJob
  queue_as :default

  def perform(couple_profile)
    unless couple_profile.secondary_user.present?
      title = couple_profile.name
      notification_message = "Add Your Partner "
      data_hash = {notificationable_id: couple_profile.id , notificationable_type: 'add_your_partner'}
      PushNotification.trigger_notification(couple_profile.primary_user, data_hash, title, notification_message)
    end
  end
end
