class Api::V1::BannersController < ApiController
  skip_before_action :authenticate_user!

  def index
    banners = Banner.all
    if banners.exists?
      render_success_response({
                                banners: banner_response(banners)
                              }, 'banners', 200)
    else
      render_unprocessable_entity('There is no banners.')
    end
  end

  private
  def banner_response(banners)
    banner_structure.map do |structure|
      if structure.is_a?(Array)
        array_serializer.new(banners.where(name: structure), serializer: Api::V1::BannerSerializer)
      else
        single_serializer.new(banners.find_by(name: structure), serializer: Api::V1::BannerSerializer)
      end
    end
  end

  def banner_structure
    [
      'post_on_social_media',
      ['spotlight_focus', 'incognito_mode'],
      'burn',
      'add_refresh_matchlist',
      ['change_location', 'save_for_later'],
      'maintain_high_karma_score',
    ]
  end
end
