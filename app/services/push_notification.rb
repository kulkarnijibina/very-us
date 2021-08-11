class PushNotification
  def self.trigger_notification(receiver, data_hash, title, message)
    push_notification = PushNotification.new
    notification = push_notification.create_notification(receiver, message, data_hash)
    if notification.present?
      data_hash[:notification_id] = notification.id
      PushNotificationJob.perform_now(receiver.id, data_hash, title, message)
    end
  end

  def create_notification(receiver, message, data)
    return receiver.notifications.create(notification_text: message, notificationable_id: data[:notificationable_id], notificationable_type: data[:notificationable_type],sender_id: data[:sender_id])
  end

end