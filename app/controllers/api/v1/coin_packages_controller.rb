class Api::V1::CoinPackagesController < ApiController

  def index
    coin_packages = CoinPackage.all.order(:amount)
    unless coin_packages.empty?
      render_success_response({
                                coin_packages: array_serializer.new(coin_packages, serializer: Api::V1::CoinPackagesSerializer)
                              }, 'coin_packages list', 200)
    else
      render_unprocessable_entity('There is no coin_packages')
    end
  end

end
