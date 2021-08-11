# frozen_string_literal: true

class Api::V1::MeetupSerializer < ActiveModel::Serializer
  attributes :id, :status, :date_time, :location, :description
  belongs_to :sender, serializer: Api::V1::CoupleProfileSerializer
  belongs_to :recipient, serializer: Api::V1::CoupleProfileSerializer
end
