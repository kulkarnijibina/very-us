# frozen_string_literal: true

class Api::V1::CoupleProfilesController < ApiController
  before_action :set_user, only: [:show]

  def current_profile
    render_success_response({
      couple_profile: single_serializer.new(current_user.couple_profile, serializer: Api::V1::CoupleProfileSerializer)
    })
  end

  def show
    is_reported = current_user.couple_profile.relationships.is_reported.where(target_couple: @user.couple_profile).exists?
    render_success_response({
                              user: single_serializer.new(@user.couple_profile, serializer: Api::V1::CoupleProfileSerializer),is_reported: is_reported
                            })
  end

  def update
    couple_profile = current_user.couple_profile
    couple_params = build_couple_profile_params(couple_profile)
    earn_on_records = current_user.couple_profile.earnon_records
    location_logger.debug({couple_profile_id: current_user.couple_profile.id, place: couple_params["place"], location: current_user.couple_profile.location }) if couple_params["place"].present?
    if couple_profile.update(couple_params)
      coins_awarded, update_message = profile_update_message(couple_params, earn_on_records)
      render_success_response({
                                user: single_serializer.new(current_user.couple_profile, serializer: Api::V1::CoupleProfileSerializer),
                                coins_awarded: coins_awarded
                              }, update_message)
    else
      render_unprocessable_entity_response(couple_profile)
    end
  end

  def change_location
    couple_profile = current_user.couple_profile
    need_to_burn_coins = current_user.couple_profile.location.present?
    target_matches = current_user.couple_profile.target_matches
    response = BurnCoinsService.call(:change_geography, couple_profile, need_to_burn_coins) do
      if couple_profile.update(location_params)
        target_couple_ids = couple_profile.save_for_later.select(:target_couple_id)
        couple_profile.matches.where.not(target_couple_id: target_couple_ids).destroy_all
        GetPredictedMatchesService.new.create_matches(couple_profile, Date.current)
        GetPredictedMatchesService.new.remove_far_target_matches(target_matches)
      else
        raise couple_profile.errors.full_messages.first
      end
    end
    location_logger.debug({couple_profile_id: current_user.couple_profile.id,place: current_user.couple_profile.place,location: current_user.couple_profile.location})
    if response[:success]
      render_success_response({ location: single_serializer.new(current_user.couple_profile.location, serializer: Api::V1::LocationSerializer), balance: response[:balance] }, "Your Location has been changed successfully!")
    else
      render_unprocessable_entity(response[:errors], {balance: response[:balance]})
    end
  end

  def get_location
    render_success_response({location: current_user.couple_profile.location})
  end

  def add_image
    couple_profile = current_user.couple_profile
    if couple_profile.update(couple_profile_image_params)
      unless couple_profile.profile_pic.present?
        couple_profile.images.first.update(is_profile_pic: true) if couple_profile.images.present?
      end
      render json: {message: "file uploaded successfully", images: array_serializer.new(couple_profile.images, serializer: Api::V1::ImageSerializer)}
    else
      render_unprocessable_entity_response(couple_profile)
    end
  end

  def remove_image
    image = current_user.couple_profile.images.find(params[:image_id])
    if image.destroy!
      render json: {message: "file deleted successfully"}
    end
  end

  def images
    images = current_user.couple_profile.images
    render_success_response({
                              user: array_serializer.new(images, serializer: Api::V1::ImageSerializer)
                            }, 'Image list', 200)
  end

  def go_incognito
    response = BurnCoinsService.call(:incognito_mode , current_user.couple_profile) do
      current_user.couple_profile.set_incognito!
    end

    if response[:success]
      render_success_response({ incognito: response[:data], balance: response[:balance] }, "Your Incognito mode is on for next #{response[:data]}.")
    else
      render_unprocessable_entity(response[:errors], {balance: response[:balance]})
    end
  end

  def use_spotlight
    response = BurnCoinsService.call(:spotlight_focus , current_user.couple_profile) do
      current_user.couple_profile.set_spotlight!
    end

    if response[:success]
      render_success_response({ spotlight: response[:data], balance: response[:balance] }, "Your Spotlight focus mode is on for next #{response[:data]}.")
    else
      render_unprocessable_entity(response[:errors], {balance: response[:balance]})
    end
  end

  def refresh_match_list
    response = BurnCoinsService.call(:refresh_match_list, current_user.couple_profile) do
      current_user.couple_profile.refresh_match_list!
    end

    if response[:success]
      render_success_response({ new_matches: response[:data], balance: response[:balance] }, 'Your Match List has been Refreshed')
    else
      render_unprocessable_entity(response[:errors], {balance: response[:balance]})
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id] )

    render_unprocessable_entity('User not found') unless @user
  end

  def build_couple_profile_params(couple_profile)
    couple_params = couple_profile_params
    if couple_params[:secondary_user_attributes].blank? && couple_profile.secondary_user.present? && couple_params[:secondary_user_details].present?
      couple_params.merge(secondary_user_attributes: couple_params[:secondary_user_details])
    else
      couple_params
    end
  end

  def couple_profile_params
    params.require(:couple_profile).permit(
             :anniversary,
             :orientation,
             :have_children,
             :have_pets,
             :do_for_fun,
             :goals,
             :values_needed,
             :chat_availability,
             :partner_number,
             :place,
             :onboarding_status,
             secondary_user_details: [ :first_name, :last_name, :smoke, :drink, :occupation, :gender, :date_of_birth, :language, :orientation, :linkedin_verified, :facebook_verified, :instagram_verified],
             primary_user_attributes: [ :first_name, :last_name, :smoke, :drink, :occupation, :gender, :date_of_birth, :language, :orientation, :linkedin_verified, :facebook_verified, :instagram_verified],
             secondary_user_attributes: [ :first_name, :last_name, :smoke, :drink, :occupation, :gender, :date_of_birth, :language, :orientation, :linkedin_verified, :facebook_verified, :instagram_verified],
             meetup_dates: [],
             personality_traits: [],
             activities: [])
  end

  def location_params
    params.require(:location).permit(location_attributes: [:latitude, :longitude])
  end

  def couple_profile_image_params
    params.require(:couple_profile).permit(:onboarding_status,
      images_attributes: [:id, :image, :is_profile_pic, :_destroy]
    )
  end

  def profile_update_message(couple_params, earn_on_records)
    if couple_params[:do_for_fun].present? && !earn_on_records["do_for_fun"]
      [true, "You have earned #{EarnOn.configuration.do_for_fun} coins for filling this answer"]
    elsif couple_params[:goals].present? && !earn_on_records["goals"]
      [true, "You have earned #{EarnOn.configuration.goals} coins for filling this answer"]
    elsif couple_params[:values_needed].present? && !earn_on_records["values_needed"]
      [true, "You have earned #{EarnOn.configuration.values_needed} coins for filling this answer"]
    else
      [false, "Couple Profile updated successfully!"]
    end
  end
end
