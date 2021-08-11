class CoupleProfile < ApplicationRecord
  # constants
  IRRELEVANT_MATCH_THRESHOLD = 10

  serialize :meetup_dates, Array

  enum status: {deactivated_by_admin: "deactivated_by_admin", deactivated_by_user: "deactivated_by_user", active: "active"}

  # belongs_to
  belongs_to :primary_user, class_name: "User", foreign_key: "primary_user_id"
  belongs_to :secondary_user, class_name: "User",foreign_key: "secondary_user_id", optional: true

  # has_many
  has_many :relationships, foreign_key: :source_couple_id, class_name: "Relationship", dependent: :destroy
  has_many :target_relationships, foreign_key: :target_couple_id, class_name: "Relationship", dependent: :destroy
  has_many :received_meetups, foreign_key: :target_couple_id, class_name: "Meetup", dependent: :destroy
  has_many :sent_meetups, foreign_key: :source_couple_id, class_name: "Meetup", dependent: :destroy
  has_many :received_meetup_feedbacks, foreign_key: :target_couple_id, class_name: "MeetupFeedback", dependent: :destroy
  has_many :sent_meetup_feedbacks, foreign_key: :source_couple_id, class_name: "MeetupFeedback", dependent: :destroy
  has_many :images, dependent: :destroy
  has_many :matches, foreign_key: :source_couple_id, class_name: "Match", dependent: :destroy
  has_many :target_matches, foreign_key: :target_couple_id, class_name: "Match", dependent: :destroy
  has_many :temp_matches, foreign_key: :source_couple_id, class_name: "TempMatch", dependent: :destroy
  has_many :target_temp_matches, foreign_key: :target_couple_id, class_name: "TempMatch", dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :couple_chats
  has_many :chats, through: :couple_chats
  has_many :sent_feedback_meetups, through: :sent_meetup_feedbacks, source: :meetup

  # has_one
  has_one :location, as: :locationable, dependent: :destroy
  has_one :wallet, dependent: :destroy

  validates :partner_number, uniqueness: { scope: [:partner_country_code] }, if: -> {self.partner_number.present?}
  validates :partner_country_code, presence: true, if: -> { will_save_change_to_partner_number? && self.partner_number.present?}
  validate :validate_incognito_mode, if: :will_save_change_to_incognito_time?
  validate :validate_spotlight_mode, if: :will_save_change_to_spotlight_on_time?
  validates :partner_number, :length => { :minimum => 7, :maximum => 15 }, :format => { with: /[0-9]+/ }, if: -> {self.partner_number.present?}

  # nested_attributes
  accepts_nested_attributes_for :location
  accepts_nested_attributes_for :primary_user, update_only: true
  accepts_nested_attributes_for :secondary_user, update_only: true
  accepts_nested_attributes_for :images, allow_destroy: true

  scope :with_personality_traits, -> { where("personality_traits != ?", '{}') }

  scope :activated_couples, -> { active }

  scope :not_in_incognito, -> { where.not('incognito_time is not null and incognito_time > ?',BurnOn.incognito_duration)}

  scope :spotlight_on, -> { where('spotlight_on_time is not null and spotlight_on_time > ?',BurnOn.spotlight_duration)}
  # validations
  validate :validate_personality_traits

  # callbacks
  before_save :set_profile_completed
  before_update :invite_partner, if: :will_save_change_to_partner_number?
  after_save :create_matches
  before_destroy :destroy_chats
  before_create :set_free_save_for_later_count
  after_initialize :set_defaults
  before_update :credit_profile_completed_and_social_media_score


  PERSONALITY_TRAITS = [
  "Athletic",
  "Creative",
  "Cultured",
  "Enthusiastic",
  "Honest",
  "Humble",
  "Humorous",
  "Innovative",
  "Intutive",
  "Leisurely",
  "Logical",
  "Optimistic",
  "Polite",
  "Realist",
  "Social",
  "Versatile",
  "Early Risers",
  "Night Owls"
]

ACTIVITIES = [
  "Dancing",
  "Foodie",
  "Gardening",
  "Hiking",
  "Photography",
  "Sports",
  "Traveling",
  "Running",
  "Yoga",
  "Gym Freaks",
  "Board Games",
  "Happy Hours",
  "DIY Enthusiasts",
  "Literature Lovers",
  "Animal Lovers",
  "Gaming",
  "Netflix & Chill",
  "Music"
]

  # public methods
  def all_meetups
    self.sent_meetups.or(self.received_meetups)
  end

  def pending_feedback_meetups
    all_meetups.accepted.where.not(id: self.sent_feedback_meetups).where('date(date_time) < ?', DateTime.current.to_date)
  end

  def received_pending_meetups
    chat_inactivity_threshold = ApplicationConfig.configuration.chat_inactivity_threshold_in_days.days.ago
    received_meetups.pending.where('created_at > ?', chat_inactivity_threshold)
  end

  def name
    [primary_user.name, secondary_user_name].compact.join(' & ')
  end

  def secondary_user_name
    secondary_user&.name || secondary_user_details["first_name"].presence
  end

  def profile_pic
    images.find_by(is_profile_pic: true) || images.first
  end

  def profile_pic_url
    profile_pic.image.service_url if profile_pic&.image&.attached?
  end

  def karma_score
    received_meetups.last(5).select{|m| ["accepted", "rejected"].include?(m.status)}.size
  end

  def get_or_build_location
    self.location || Location.new
  end

  def get_distance_with(other_couple)
    couple_profile_1_location = self.get_or_build_location
    couple_profile_2_location = other_couple.get_or_build_location
    Geocoder::Calculations.distance_between(
      [couple_profile_1_location.latitude, couple_profile_1_location.longitude],
      [couple_profile_2_location.latitude, couple_profile_2_location.longitude]
    )
  end

  def get_wallet
    self.wallet || create_wallet
  end

  def wallet_balance
    get_wallet.get_balance
  end

  def incognito
    incognito_time.present? && incognito_time > BurnOn.incognito_duration
  end

  def spotlight_on
    spotlight_on_time.present? && spotlight_on_time > BurnOn.spotlight_duration
  end

  def get_matches_for_the_day(date)
    if date.blank? || DateTime.parse(date) == Date.current
      matches
    else
      date = DateTime.parse(date)
      GetPredictedMatchesService.new.call(self, date)
    end
  end

  def check_daily_save_for_later_available?
    free_save_for_later_count > 0
  end

  def can_use_free_save_for_later?(target_couple_id)
    check_daily_save_for_later_available? && save_for_later.where(target_couple_id: target_couple_id).blank?
  end

  def use_free_save_for_later_if_available!(target_couple_id)
    update!(free_save_for_later_count: free_save_for_later_count-1) if can_use_free_save_for_later?(target_couple_id)
  end

  def validate_incognito_mode
    if spotlight_on
      errors.add(:base, "Can't Activate Incognito With Spotlight Mode")
    end
  end

  def validate_spotlight_mode
    if incognito
      errors.add(:base, "Can't activate spotlight with incognito mode")
    end
  end

  def refresh_match_list!
    new_matches = GetPredictedMatchesService.new(BurnOn.configuration.refresh_matches_count).create_matches(self, Date.current)
    if new_matches.present?
      new_matches
    else
      raise 'No New Matches Found'
    end
  end

  def set_incognito!
    if incognito
      raise 'Incognito Mode Already Activated'
    else
      unless update(incognito_time: DateTime.current)
        raise errors.full_messages.first
      end
    end
    "#{BurnOn.configuration.incognito_duration_in_mins} mins"
  end

  def build_save_for_later_relationship(target_couple_id, action)
    relationship = self.save_for_later.where(target_couple_id: target_couple_id).last
    if relationship.present?
      action_expiration = relationship.action_expiration + BurnOn.per_save_for_later_duration
    else
      relationship = self.relationships.save_for_later.find_or_initialize_by(target_couple_id: target_couple_id)
      action_expiration = BurnOn.per_save_for_later_duration.from_now
      use_free_save_for_later_if_available!(target_couple_id)
    end
    relationship.assign_attributes(action_expiration: action_expiration)
    relationship
  end

  def build_irrelevant_relationship(relationship_params)
    self.matches.where(target_couple_id: relationship_params[:target_couple_id]).destroy_all
    action = relationship_params[:action]
    if self.relationships.find_by(target_couple_id: relationship_params[:target_couple_id], action: action)
      raise relationship_action_message(action)
    end
    self.relationships.build(relationship_params)
  end

  def set_spotlight!
    if spotlight_on
      raise 'Spotlight Mode Already Activated'
    else
      unless update(spotlight_on_time: DateTime.current)
        raise errors.full_messages.first
      end
    end
    "#{BurnOn.configuration.spotlight_duration_in_mins} mins"
  end

  def save_for_later
    relationships.save_for_later.where('action_expiration > ?',DateTime.current)
  end

  def unread_chats
    deleted_chat_ids = self.couple_chats.where(is_deleted: true).pluck(:chat_id)

    chat_inactivity_threshold = ApplicationConfig.configuration.chat_inactivity_threshold_in_days.days.ago
    chat_ids = self.chats.joins(:messages)
      .where("(messages.created_at > ? AND messages.couple_profile_id <> ?) OR (chats.created_at > ?)", chat_inactivity_threshold, self.id, chat_inactivity_threshold)
      .distinct.ids
    chat_ids = chat_ids - deleted_chat_ids
    chats.where(id: chat_ids).includes(:messages).where.not(messages:{couple_profile_id: self.id, is_mark_read:true}).order('messages.created_at DESC').distinct
  end

  def get_match_percentage(couple_profile_2)
    common_traits = get_common_traits(couple_profile_2)
    if common_traits.count > 0
      (common_traits.count.to_f/ get_effective_traits.count)* 100
    else
      0
    end
  end

  def get_effective_traits
    personality_traits.first(6) + activities.first(6)
  end

  def get_common_traits(couple_profile_2)
   self.get_effective_traits & couple_profile_2.get_effective_traits
  end

  def set_and_update_irrelevant_match_counter(irrelevant_matches, source_couple_id)
    irrelevant_matches = personality_traits & irrelevant_matches
    removeable_personality_traits = []
    irrelevant_matches.map do |irrelevant_match|
      if irrelevant_match_counter.key?(irrelevant_match)
        irrelevant_match_counter[irrelevant_match.to_s] << source_couple_id
        removeable_personality_traits.push(irrelevant_match) if irrelevant_trait?(irrelevant_match)
      else
        irrelevant_match_counter[irrelevant_match.to_s] = [source_couple_id]
      end
    end
    self.personality_traits = personality_traits - removeable_personality_traits unless removeable_personality_traits.empty?
    save
  end

  def irrelavant_and_reported_relationships
    self.relationships.where(action: ["is_irrelevant_match", "is_reported"])
  end

  def upcoming_meetups
    all_meetups.accepted.where('date_time > ?', DateTime.current)
  end

  private
  def set_defaults
    self.chat_availability = true if chat_availability.nil?
  end

  def invite_partner
    if partner_number.present?
      full_phone_number = partner_country_code.to_s + partner_number.to_s
      message = """#{primary_user.name} has invited u as partner to join the VeryUs app

      #{ENV["PLAYSTORE_APP_LINK"]}
      """
      response = SmsService.call(full_phone_number, message)
      unless response[:success]
        errors.add(:partner_number, response[:error])
        throw(:abort)
      end
    end
  end

  def validate_personality_traits
    personality_traits.each do |personality_trait|
      if irrelevant_trait?(personality_trait)
        errors.add(:personality_traits, I18n.t("models.couple_profile.messages.personality_traits_validation", trait: personality_trait))
      end
    end
  end

  def irrelevant_trait?(irrelevant_match)
    (irrelevant_match_counter[irrelevant_match]&.size || 0) >= IRRELEVANT_MATCH_THRESHOLD
  end

  def set_profile_completed
    if primary_user
      self.profile_completed = check_profile_completed()
    end
  end

  def check_profile_completed
    fields = user_fields.map{|field| primary_user.send(field) } +
      user_fields.map{|field| secondary_user_attrs[field] } +
      couple_fields.map{|field| !self.send(field).nil? } +
      [[do_for_fun, goals, values_needed].reject(&:blank?).present?]
    fields.all? { |field| field.present?}
  end

  def secondary_user_attrs
    secondary_user&.attributes || secondary_user_details
  end

  def create_matches
    if first_time_change_to_personality_trait && personality_traits.present? && activities.present?
      matches.destroy_all
      GetPredictedMatchesService.new.create_matches(self, Date.current)
      update(first_time_change_to_personality_trait: false)
    end
  end

  def destroy_chats
    chats.each(&:destroy)
  end

  def set_free_save_for_later_count
    self.free_save_for_later_count = BurnOn.configuration.daily_free_per_save_for_later
  end

  def couple_fields
    [
      "have_pets",
      "have_children",
    ]
  end

  def user_fields
    [
      "first_name",
      "gender",
      "orientation",
      "date_of_birth",
      "smoke",
      "drink",
      "occupation",
      "language",
    ]
  end

  def credit_profile_completed_and_social_media_score
    if !earnon_records["profile_completed"] && profile_completed
      AddEarnCoinsService.call(:profile_completed_score, self)
      self.earnon_records["profile_completed"] = true
    end
    if !earnon_records["social_media_connected"] && primary_user.linkedin_verified && primary_user.facebook_verified && primary_user.instagram_verified
      AddEarnCoinsService.call(:social_media_connected, self)
      self.earnon_records["social_media_connected"] = true
    end
    if !earnon_records["do_for_fun"] && self.do_for_fun.present?
      AddEarnCoinsService.call(:do_for_fun, self)
      self.earnon_records["do_for_fun"] = true
    end
    if !earnon_records["goals"] && self.goals.present?
      AddEarnCoinsService.call(:goals, self)
      self.earnon_records["goals"] = true
    end
    if !earnon_records["values_needed"] && self.values_needed.present?
      AddEarnCoinsService.call(:values_needed, self)
      self.earnon_records["values_needed"] = true
    end

  end

  def relationship_action_message(action)
    case action
    when "is_irrelevant_match"
      "Already marked couple as irrelevant"
    when "is_reported"
      "Already marked couple as reported"
    end
  end

end
