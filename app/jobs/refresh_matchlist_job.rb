class RefreshMatchlistJob < ApplicationJob
  queue_as :default

  def perform
    get_predicted_matches_service = GetPredictedMatchesService.new
    ApplicationConfig.configuration.update(matchlist_job_run_time: (Time.current + ApplicationConfig.configuration.matchlist_scheduler_time_in_hours.hours))

    CoupleProfile.all.each do |couple_profile_1|
      target_couple_ids = couple_profile_1.save_for_later.select(:target_couple_id)
      couple_profile_1.matches.where.not(target_couple_id: target_couple_ids).destroy_all
      get_predicted_matches_service.create_matches(couple_profile_1, Date.current) if couple_profile_1.active?
    end

    CoupleProfile.active.each do |couple_profile_1|
      title = couple_profile_1.name
      notification_message = "Your matchlist has been refreshed!"
      data_hash = {notificationable_id: couple_profile_1.id , notificationable_type: 'matchlist_refreshed'}
      PushNotification.trigger_notification(couple_profile_1.primary_user, data_hash, title, notification_message)
      PushNotification.trigger_notification(couple_profile_1.secondary_user, data_hash, title, notification_message) if couple_profile_1.secondary_user.present?
    end
  end
end
