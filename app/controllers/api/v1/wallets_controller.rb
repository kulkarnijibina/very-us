class Api::V1::WalletsController < ApiController
  before_action :set_wallet

  def add_money
    coin_package = CoinPackage.find(params[:wallet][:coin_package_id])
    response = create_payment(wallet_params.merge(amount: coin_package.coins, stripe_amount: coin_package.amount), current_user)
    if response[:success]
      create_transaction(response[:data], coin_package.coins)
    else
      render_unprocessable_entity(response[:error])
    end
  end

  def balance
    render_success_response({ wallet_balance: @wallet.get_balance }, 'Wallet balance fetched successfully!')
  end

  def transactions
    transactions = paginate @wallet.transactions.includes(:balance_log).order(created_at: :desc)
    render_success_response({ wallet_transactions: array_serializer.new(transactions, serializer: Api::V1::TransactionSerializer), wallet_balance: @wallet.get_balance }, 'Wallet transactions fetched successfully!')
  end

  def onboarding_reward_collected
    transactions = @wallet.transactions.where( transaction_purpose: "onboarding")
    render_success_response({ wallet_transactions:transactions}, 'Wallet transactions fetched successfully!')
  end

  private
  def set_wallet
    @wallet = current_user.couple_profile.get_wallet
  end

  def create_payment(stripe_params, user)
    Stripe::StripeBaseClass.new(stripe_params, user).create_payment
  end

  def create_transaction(payment, coins)
    transaction = @wallet.credit_amount(coins, "Added money to Wallet", "wallet_topup", payment)
    if transaction.persisted?
      render_success_response({ transaction: transaction, wallet_balance: @wallet.get_balance }, 'Added money to wallet successfully!')
    else
      render_unprocessable_entity_response(transaction)
    end
  end

  def wallet_params
    params.require(:wallet).permit(:stripe_token, :stripe_card_token, :state,:address_line_1, :postal_code, :city, :country)
  end
end
