class EarnOn < ApplicationRecord
  include Configuration

  ONBOARDING    = [:onboarding, :partner_app_download,:profile_completed_score,:social_media_connected,:do_for_fun,:goals,:values_needed].freeze
  CHAT_INVITE   = [:per_accept_chat, :initial_response].freeze
  VERIFICATION  = [:verification_status].freeze
  FEEDBACK      = [:feedback_fill_per_couple_meet].freeze
  REWARD_KARMA_SCORE = [:reward_points_to_karma_score].freeze
  ALL_OPTIONS = {
    'Onboarding' => ONBOARDING,
    'Chat/Invite' => CHAT_INVITE,
    'Verification' => VERIFICATION,
    'Feedback' => FEEDBACK,
    'Reward Karma Score' => REWARD_KARMA_SCORE,
  }.freeze

  DEFAULTS = {
    onboarding: 6,
    partner_app_download: 2,
    per_accept_chat: 0.5,
    initial_response: 0.5,
    verification_status: 2,
    feedback_fill_per_couple_meet: 1,
    reward_points_to_karma_score: 200,
    profile_completed_score: 100,
    social_media_connected: 100,
    do_for_fun: 100,
    goals: 100,
    values_needed: 100,
  }.freeze

  after_initialize :set_defaults

  def self.configuration
    active.first
  end

  def self.get_label(field)
    I18n.t("models.earn_on.label.#{field}")
  end

  private
  def set_defaults
    DEFAULTS.each do |k,v|
      self.send("#{k}=", send(k) || v)
    end
  end
end
