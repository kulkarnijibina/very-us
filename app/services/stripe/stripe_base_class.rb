# frozen_string_literal: true

module Stripe
  class StripeBaseClass
    DEFAULT_CURRENCY = 'usd'

    attr_accessor :user,  :stripe_token

    def initialize(params, user)
      @stripe_token = params[:stripe_token]
      @stripe_card_token = params[:stripe_card_token]
      @amount = params[:stripe_amount]
      @user = user
      @currency = params[:currency] ||  DEFAULT_CURRENCY
      @address_line_1 = params[:address_line_1]
      @postal_code = params[:postal_code]
      @city = params[:city]
      @country = params[:country]
    end

    def create_payment
      begin
        customer = get_customer
        card = save_card_to_stripe
        charge = create_charge(customer, @amount)
        payment = payment_history(amount:@amount, stripe_charge_id:charge.id, status:charge.status)

        {data:payment, success: true}
      rescue *exceptions => e
        {error: e.message, error_code: e.code,  success: false }
      end
    end

    private

    def exceptions
      [
        Stripe::CardError,
        Stripe::RateLimitError,
        Stripe::InvalidRequestError,
        Stripe::AuthenticationError,
        Stripe::APIConnectionError,
        Stripe::StripeError,
      ]
    end


    def get_customer
      stripe_customer_id = @user.stripe_customer_id
      if stripe_customer_id.present?
        Stripe::Customer.retrieve(stripe_customer_id)
      else
        create_customer
      end
    end

    def save_card_to_stripe
      customer = get_customer
      card = Stripe::Customer.create_source(
        customer.id.to_s,
        {
        source: @stripe_token
        }
      )
      @user.update(is_card_details_exists: true, stripe_card_id: card.id) if card.present? && !(@user.stripe_card_id == card.id)
      card
    end

   def create_charge(customer, payable_amount)
    Stripe::Charge.create(
      customer: customer,
      amount: (payable_amount*100).to_i,
      currency: @currency,
      description: "Charge for #{@user.contact}",
      source: @stripe_card_token,
      shipping: {
        name: @user.name,
        address: {
          line1: @address_line_1,
          postal_code: @postal_code,
          city: @city,
          state: @state,
          country: @country
        }
      }
    )
    end

    def create_customer
      customer = Stripe::Customer.create(
        name: @user.name,
        email: "#{@user.contact}@veryus.com",
        description: "Customer for #{@user.contact}"
      )
      @user.stripe_customer_id = customer.id
      @user.save
      customer
    end

    def payment_history(options = {})
      Payment.create(amount: options[:amount],
                     # remarks: options[:remarks],
                     user: user,
                     stripe_charge_id: options[:stripe_charge_id],
                     status: options[:status])
    end

  end
end