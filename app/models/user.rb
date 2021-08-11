# frozen_string_literal: true

class User < ApplicationRecord
  # has_secure_password

  # Add config for profile image

  has_one :jwt_allow_list, dependent: :destroy
  has_many :suggest_activities, dependent: :destroy
  has_many :mobile_devices, dependent: :destroy
  has_many :notifications, class_name: "Notification", foreign_key: "receiver_id"

  accepts_nested_attributes_for :mobile_devices

  before_destroy :delete_secondary_user

  # Associations for the model

  # Validation of the params
  validates :contact, presence: true, uniqueness: { scope: [:country_code], :message => 'Has Already Been Taken' }
  validates :country_code, presence: true
  validates :contact, :length => { :minimum => 7, :maximum => 15 }, :format => { with: /[0-9]+/ }
  validate :validate_age

  # callbacks
  before_create :send_otp
  before_validation :fix_country_code_format

  def valid_otp?(entered_otp)
    return false if entered_otp.blank?

    if Rails.env.production?
      otp == entered_otp
    else
      (otp == entered_otp) || (entered_otp.to_s == '123456')
    end
  end

  def name
    first_name.presence || contact
  end

  def couple_profile
    CoupleProfile.where("primary_user_id = ? OR secondary_user_id = ?", self.id, self.id).first
  end

  def delete_secondary_user
    return unless couple_profile
    partner_obj = partner
    couple_profile.destroy!
    partner_obj.destroy! if partner_obj.present?
  end

  def partner
    return unless couple_profile
    if couple_profile.primary_user_id != id
      couple_profile.primary_user
    else
      couple_profile.secondary_user
    end
  end

  def generate_and_send_otp
    send_otp
    save
  end

  def send_otp
    otp = generate_otp
    full_phone_number = country_code.to_s + contact.to_s
    message = """<#> Welcome to VeryUS. #{otp} is your OTP for signing in.
    Thanks

    #{ENV['OTP_HASH_STRING']}"""

    response = SmsService.call(full_phone_number, message)
    unless response[:success]
      errors.add(:contact, response[:error])
      throw(:abort)
    end
  end

  # def skip_reconfirmation!
  #   @bypass_confirmation_postpone = true
  # end

  ORIENTATION =  ["Straight", "Gay ","BiSexual", "Trans", "Lesbian", "Other"]

  private

  def generate_otp
    self.otp = rand.to_s[2..7]
  end

  def validate_age
    if date_of_birth.present? && date_of_birth >= 18.years.ago.to_date
      errors.add(:date_of_birth, 'You should be 18 or over 18 years old.')
    end
  end

  def fix_country_code_format
    self.country_code = "+" + self.country_code.to_i.to_s if country_code.present?
  end
end
