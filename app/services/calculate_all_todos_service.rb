module CalculateAllTodosService
  class << self

    def call(user)
      todos = []
      TodoDetail.names.keys.map do |key|
        todo = todo_rule(key, user)
        if todo.present?
          todos << todo
        end
      end
      todos = TodoDetail.where(name: todos)
    end

    def todo_rule(key, user)
      case key
      when 'complete_your_profile'
        key unless user.couple_profile.profile_completed

      when 'link_social_media_accounts'
        key unless user.linkedin_verified and user.facebook_verified and user.instagram_verified

      when 'add_availability'
        key unless user.couple_profile.meetup_dates.present?

      when 'add_photos'
        key if user.couple_profile.images.count < 6

      when 'reminder_to_respond_to_meeting_invite'
        key if user.couple_profile.received_pending_meetups.exists?

      when 'respond_to_any_and_all_new_interactions'
        key if user.couple_profile.unread_chats.exists?

      when 'invite_partner'
        key unless user.couple_profile.partner_number.present? or user.couple_profile.secondary_user.present?

      when 'meetup_feedback'
        key if user.couple_profile.pending_feedback_meetups.exists?

      when 'upcoming_meetup'
        key if user.couple_profile.upcoming_meetups.exists?

      when 'do_for_fun'
        key if user.couple_profile.do_for_fun.blank?

      when 'goals'
        key if user.couple_profile.goals.blank?

      when 'values_needed'
        key if user.couple_profile.values_needed.blank?
      end

    end

  end
end