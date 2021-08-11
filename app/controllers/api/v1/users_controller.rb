# frozen_string_literal: true

class Api::V1::UsersController < ApiController

  skip_before_action :authenticate_user!, except: [:invite_partner, :matches, :irrelevant_matches]

  before_action :validate_and_set_user, only: [:login]

  before_action :check_otp_verified, only: [:create]
  before_action :validate_partner_not_present, only: [:create]

  def create
    resource = User.new(sign_up_params)
    User.transaction do
      begin
        if resource.save
          if CoupleProfile.where(partner_number: params[:user][:contact], partner_country_code: params[:user][:country_code]).blank?
            CoupleProfile.create!(primary_user_id: resource.id)
            AddEarnCoinsService.call(:onboarding, resource.couple_profile)
          else
            couple_profile = CoupleProfile.find_by!(partner_number: params[:user][:contact], partner_country_code: params[:user][:country_code]).update!(secondary_user: resource)
            secondary_user_details = resource.couple_profile.secondary_user_details
            resource.update!(secondary_user_details)
            AddEarnCoinsService.call(:partner_app_download, resource.couple_profile)
          end
          CompleteProfileJob.set(wait: complete_profile_notification_time.hours).perform_later(resource.couple_profile)
          AddYourPartnerJob.set(wait: add_partner_notification_time.hours).perform_later(resource.couple_profile)
        else
          return render_unprocessable_entity_response(resource)
        end
      rescue => exception
        @response = {success: false, errors: exception}
        raise ActiveRecord::Rollback
      end
      @response = {success: true}
    end
    if @response[:success]
      render_success_response({
        user: single_serializer.new(resource, serializer: Api::V1::UserSerializer)
      }, 'User created sucessfully')
    else
      render_unprocessable_entity(@response[:errors])
    end
  end

  def sign_up_as_partner
    if CoupleProfile.where(partner_number: params[:user][:contact], partner_country_code: params[:user][:country_code]).present?
      self.create unless check_otp_verified
    else
      render_unprocessable_entity("No Partner found")
    end
  end

  def resend_otp
    user = User.find_by(contact: params[:user][:contact], country_code: params[:user][:country_code])
    return render_unprocessable_entity('User not found') unless user.present?
    user.generate_and_send_otp
    render_success_response({
                              user: single_serializer.new(user, serializer: Api::V1::UserSerializer)
                            }, 'Otp send successfully')
  end

  def login
    if @user.valid_otp?(params[:user][:otp])
      @user.update(otp_verified: true)
      auth_token = JsonWebToken.encode({ user_id: @user.id })
      JsonWebToken.add_token(@user, auth_token)
      render_success_response({
                                user: single_serializer.new(@user, serializer: Api::V1::UserSerializer).as_json.merge(partner_name: @user.partner&.name),
                                token: JsonWebToken.encode(user_id: @user.id)
                              }, 'Login successful.', 200)
    else
      render_unprocessable_entity('Otp is incorrect.', nil, :otp_incorrect)
    end
  end

  def invite_partner
    render_unprocessable_entity "Number already registered" and return if User.where(contact: params[:partner_number], country_code: params[:country_code]).present?
    couple_profile = current_user.couple_profile
    if couple_profile.update(partner_number: params[:partner_number], partner_country_code: params[:country_code])
      render_success_response "User invited successfully"
    else
      render_unprocessable_entity_response(couple_profile)
    end
  end

  def matches
    spotlight_matches = current_user.couple_profile.matches.spotlight_on.activated_couples
    ordinary_matches = current_user.couple_profile.matches.where.not(id: spotlight_matches).not_incognito.activated_couples
    matches = spotlight_matches + ordinary_matches
    save_for_later_couples = current_user.couple_profile.save_for_later
    render_success_response({
                              user: array_serializer.new(matches, serializer: Api::V1::MatchSerializer, save_for_later_couples: save_for_later_couples),
                              free_save_for_later_count: current_user.couple_profile.free_save_for_later_count,
                              matchlist_refresh_time_remaining_in_secs: matchlist_refresh_time_remaining_in_secs
                            }, 'Matches list', 200)
  end

  def irrelevant_matches
    irrelevant_couple = current_user.couple_profile.matches.find(params[:match_id])
    if irrelevant_couple.target_couple.set_and_update_irrelevant_match_counter(params[:irrelevant_traits], current_user.couple_profile.id)
      render_success_response({},'sucessfully marked irrelevant traits.')
    else
      render_unprocessable_entity_response(irrelevant_couple)
    end
  end

  def matchlist_timer
    render_success_response({matchlist_refresh_time_remaining_in_secs: matchlist_refresh_time_remaining_in_secs})
  end

  def suggest_activity
    suggest_activity = current_user.suggest_activities.new(name: params[:name])
    if suggest_activity.save
      render_success_response({
                                suggest_activity: single_serializer.new(suggest_activity, serializer: Api::V1::SuggestActivitySerializer)
                              }, 'Suggest Activity created sucessfully', 200)
    else
      render_unprocessable_entity_response(suggest_activity)
    end
  end

  def application_config
    render_success_response({ application_config: single_serializer.new(ApplicationConfig.configuration, serializer: Api::V1::ApplicationConfigSerializer)
                               }, 'Application Config fetched sucessfully!')
  end

  private

  def sign_up_params
    params.require(:user).permit(:country_code, :contact)
  end

  def validate_and_set_user
    @user = User.find_by(contact: params[:user][:contact], country_code: params[:user][:country_code])
    return render_unprocessable_entity('The number is not registered') unless @user
    render_unprocessable_entity('Sorry, your profile is deactivated by admin') if @user.couple_profile.deactivated_by_admin?
    @user.couple_profile.active! if @user.couple_profile.deactivated_by_user?
  end

  def check_otp_verified
    user = User.find_by(contact: params[:user][:contact], country_code: params[:user][:country_code], otp_verified: false)
    if user
      user.generate_and_send_otp
      return render_success_response({
                              user: single_serializer.new(user, serializer: Api::V1::UserSerializer)
                            }, 'Otp send successfully')
    end
  end

  def validate_partner_not_present
    if CoupleProfile.where(partner_number: params[:user][:contact], partner_country_code: params[:user][:country_code]).exists?
      render_unprocessable_entity('Sorry, this number is invited as partner please try to join as partner')
    end
  end

  def matchlist_refresh_time_remaining_in_secs
   ApplicationConfig.configuration.matchlist_job_run_time.to_i - Time.current.to_i
  end

  def complete_profile_notification_time
     ApplicationConfig.configuration.complete_profile_notify_time_in_hours
  end

  def add_partner_notification_time
    ApplicationConfig.configuration.add_partner_notify_time_in_hours
  end
end
