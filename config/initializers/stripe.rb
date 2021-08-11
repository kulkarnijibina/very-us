# frozen_string_literal: true

Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABE_KEY'],
  secret_key: ENV['STRIPE_SECRET_KEY']
}

Stripe.api_key = ENV['STRIPE_SECRET_KEY']
