module SendCoinsToProfileService
  class << self
    def call(couple_profiles, coins, description, transaction_purpose)
      Transaction.transaction do
        begin
          create_transactions(couple_profiles, coins, description, transaction_purpose)
        rescue => exception
          @response = {success: false, errors: exception.message}
          raise ActiveRecord::Rollback
        end
        @response = {success: true, message: "Successfully disperse coins."}
      end
      @response
    end

    private

    def create_transactions(couple_profiles, coins, description, transaction_purpose)
      couple_profiles.each do |couple_profile|
        wallet = couple_profile.get_wallet
        transaction = wallet.credit_amount(coins.to_i, description, transaction_purpose)
        unless transaction.persisted?
          @response = {success: false, errors: transaction.errors.full_messages.first}
          raise @response[:errors]
        end
      end
    end
  end
end