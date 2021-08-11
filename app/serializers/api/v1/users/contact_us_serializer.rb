# frozen_string_literal: true

class Api::V1::Users::ContactUsSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :email,
             :message
end
