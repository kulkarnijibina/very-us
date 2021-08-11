class Api::V1::BurnCoinsFeaturesController < ApiController

  skip_before_action :authenticate_user!

  def index
    burn_coins_features = BurnCoinsFeature.all
    unless burn_coins_features.empty?
      render_success_response({
                                burn_coins_features: array_serializer.new(burn_coins_features, serializer: Api::V1::BurnCoinsFeatureSerializer)
                              }, 'burn coins features', 200)
    else
      render_unprocessable_entity('There is no burn coins features.')
    end
  end

end
