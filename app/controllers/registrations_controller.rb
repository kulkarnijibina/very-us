# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  include ApplicationMethods
  skip_before_action :authenticate_user!, raise: false

end
