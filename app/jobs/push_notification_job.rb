class PushNotificationJob < ApplicationJob
  queue_as :critical

  def perform(receiver_id, data_hash, title, message)
    send_notification(receiver_id, data_hash, title, message)
  end

  def send_notification(receiver_id, data, title, message)
    registration_ids = MobileDevice.where(user_id: receiver_id).pluck(:device_id)
    options = {
                priority: 'high',
                data: {notification_id: data[:notification_id], data: data},
                collapse_key: "updated_score",
                sound:  'default',
                displayInForeground: true,
                notification: {
                    id: data[:notification_id], 
                    title: title, 
                    body: message,
                    sound:  'default',
                    _displayInForeground: true
                  }
                }
    if registration_ids.present? 
      response = FCM_CLIENT.send(registration_ids, options)
      puts "SendNotification response: #{response}"
    else
      puts "SendNotification response: No device registration id for user: #{receiver_id}"
    end
  end
end 
 

