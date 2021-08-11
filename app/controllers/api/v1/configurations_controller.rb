class Api::V1::ConfigurationsController < ApiController
  def earn
    render_success_response({ earn_configuration: serialize_earn_on, couple_name: current_user.couple_profile.name }, 'Earn configurations fetched sucessfully!')
  end

  def burn
    render_success_response({ burn_configuration: BurnOn.configuration }, 'Burn configurations fetched sucessfully!')
  end

  private
  def serialize_earn_on
    @wallet = current_user.couple_profile.get_wallet
    amount = @wallet.transactions.where( transaction_purpose: "onboarding").first.amount
    EarnOn.configuration.as_json.merge(onboarding: amount)
  end
end
