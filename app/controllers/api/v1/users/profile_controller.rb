# frozen_string_literal: true

class Api::V1::Users::ProfileController < ApiController

  def show
    render_success_response({ users: single_serializer.new(current_user, serializer: Api::V1::UserSerializer,  url: current_user.profile_image.attached? ? url_for(current_user.profile_image) : nil ) }, 'Your profile details are....')
  end

  def update
    unless current_user.update(update_params)
      return render_unprocessable_entity('Something goes wrong, profile is not updated')
    end
    render_success_response({ users: single_serializer.new(current_user, serializer: Api::V1::UserSerializer) }, 'Your profile updated sucessfully')
  end

  def deactivate
    current_user.couple_profile.deactivated_by_user!
    render_success_response({}, "Couple deactivated successfully!")
  end

  private

  def update_params
    params.require(:user).permit(:first_name, :last_name, :smoke, :drink, :occupation, :contact, :gender, :date_of_birth, :language, :orientation, :linkedin_verified, :facebook_verified, :instagram_verified)
  end
end
