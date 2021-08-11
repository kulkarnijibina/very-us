# BurnCoinsService.call(type, couple_profile, true_or_false) do
#   User.first.update # some burn coin operation
# end

module BurnCoinsService
  class << self
    def call(type, couple_profile, need_to_burn_coins=true)
      BurnOn.transaction do
        if block_given?
          begin
            data = yield
          rescue => exception
            @response = {success: false, errors: exception.message, balance: get_balance(couple_profile)}
            raise ActiveRecord::Rollback
          end
        end

        if need_to_burn_coins
          burn_coins_and_set_response_on_error!(type, couple_profile)
        end
        @response = {success: true, balance: get_balance(couple_profile), data: data}
      end
      @response
    end

    private
    def burn_coins_and_set_response_on_error!(type, couple_profile)
      transaction = burn_coins(type, couple_profile)
      unless transaction.persisted?
        @response = {success: false, errors: transaction.errors.full_messages.first, balance: get_balance(couple_profile)}
        raise ActiveRecord::Rollback
      end
    end

    def burn_coins(type, couple_profile)
      burned_coins = get_burned_coins_on(type)
      wallet = couple_profile.get_wallet
      description = get_description(type)
      wallet.debit_amount(burned_coins, description, type)
    end

    def get_balance(couple_profile)
      couple_profile.get_wallet.get_balance
    end

    def get_burned_coins_on(type)
      burn_on_config.send(type)
    end

    def burn_on_config
      BurnOn.configuration
    end

    def get_description(type)
      type_label = BurnOn.get_label(type)
      I18n.t("models.wallet.messages.burned_coins", type: type_label)
    end
  end
end
