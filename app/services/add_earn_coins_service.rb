# AddEarnCoinsService.call(type, couple_profile)
module AddEarnCoinsService
  class << self
    def call(type, couple_profile)
      earned_coins = get_earned_coins_on(type)
      wallet = couple_profile.get_wallet
      description = get_description(type)
      txn = wallet.credit_amount(earned_coins, description, type)
      {success: true, txn: txn, earned_coins: earned_coins}
    end

    private
    def get_earned_coins_on(type)
      earn_on_config.send(type)
    end

    def earn_on_config
      EarnOn.configuration
    end

    def get_description(type)
      type_label = EarnOn.get_label(type)
      I18n.t("models.wallet.messages.earned_coins", type: type_label)
    end
  end
end
