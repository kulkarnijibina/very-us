class FillFeedbackJob < ApplicationJob
  queue_as :default

  def perform(couple_profile,meetup)
    unless couple_profile.sent_meetup_feedbacks.where(meetup: meetup).exists?
      title = couple_profile.name
      notification_message = "Fill feedback for couple "
      data_hash = {notificationable_id: meetup.id , notificationable_type: 'fill_feedback'}
      PushNotification.trigger_notification(couple_profile.primary_user, data_hash, title, notification_message)
      PushNotification.trigger_notification(couple_profile.secondary_user, data_hash, title, notification_message) if couple_profile.secondary_user.present?
    end
  end
end