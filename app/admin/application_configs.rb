ActiveAdmin.register ApplicationConfig do
  permit_params :admin_contact_email, :status, :irrelevant_match_reasons, :report_couple_reasons, :chat_inactivity_threshold_in_days,:reward_karma_score_time_in_hours,:save_for_later_scheduler_time_in_hours,:matchlist_scheduler_time_in_hours,:refresh_free_save_for_later_time_in_hours,
  :complete_profile_notify_time_in_hours, :add_partner_notify_time_in_hours, :fill_feedback_notify_time1_in_hours, :fill_feedback_notify_time2_in_hours

  scope :active, default: true
  scope :inactive

  actions :all
  config.filters = false

  index do
    selectable_column
    id_column
    column :admin_contact_email
    column :chat_inactivity_threshold_in_days
    column :irrelevant_match_reasons do |object|
      content_tag :pre, object.irrelevant_match_reasons
    end
    column :report_couple_reasons do |object|
      content_tag :pre, object.report_couple_reasons
    end
    column :status
    column :created_at
    actions
  end

  controller do
    def update
      super do |success, failure|
        success.html do
          UpdateCrontabService.call
          redirect_to admin_application_config_path
        end
        failure.html do
          render edit_admin_application_config
        end
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :admin_contact_email
      f.input :chat_inactivity_threshold_in_days
      f.input :irrelevant_match_reasons, as: :text, hint: "add new reason in a separate line"
      f.input :report_couple_reasons, as: :text, hint: "add new reason in a separate line"
      f.input :status
      f.input :reward_karma_score_time_in_hours
      f.input :save_for_later_scheduler_time_in_hours
      f.input :matchlist_scheduler_time_in_hours
      f.input :refresh_free_save_for_later_time_in_hours
      f.input :complete_profile_notify_time_in_hours
      f.input :add_partner_notify_time_in_hours
      f.input :fill_feedback_notify_time1_in_hours
      f.input :fill_feedback_notify_time2_in_hours
    end
    f.actions
  end
end