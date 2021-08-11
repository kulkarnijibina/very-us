class ApplicationConfig < ApplicationRecord
	include Configuration

  MAX_REASON_LENGTH = 30

  validates :admin_contact_email, presence: true
  validate :validate_report_couple_reasons

  after_initialize :set_defaults

  class << self
    def configuration
      active.first
    end

    def get_label(field)
      I18n.t("models.application_config.label.#{field}")
    end
  end

  def serialize_report_couple_reasons
    report_couple_reasons.split("\n").map(&:chomp).reject(&:blank?)
  end

  private
  def set_defaults
    self.admin_contact_email ||= 'support@veryus.com'
    self.irrelevant_match_reasons ||= 'Not a real couple'
    self.report_couple_reasons ||= 'Not a real couple'
    self.chat_inactivity_threshold_in_days ||= 10
    self.complete_profile_notify_time_in_hours ||= 72
    self.add_partner_notify_time_in_hours ||= 72
    self.fill_feedback_notify_time1_in_hours ||= 24
    self.fill_feedback_notify_time2_in_hours ||= 48
    self.reward_karma_score_time_in_hours ||= 24
    self.save_for_later_scheduler_time_in_hours||= 24
    self.matchlist_scheduler_time_in_hours||= 24
    self.refresh_free_save_for_later_time_in_hours||= 24
  end

  def validate_report_couple_reasons
    serialize_report_couple_reasons.each_with_index do |reason, index|
      return errors.add(:report_couple_reasons, "Reason #{index+1} can't be greater than #{MAX_REASON_LENGTH} characters") if reason.length > MAX_REASON_LENGTH
    end
  end
end
