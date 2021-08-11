# frozen_string_literal: true

class Api::V1::MatchSerializer < ActiveModel::Serializer
  attributes :id,
             :percentage,
             :save_for_later,
             :save_for_later_expiration

  def save_for_later
    @instance_options[:save_for_later_couples] &&
      @instance_options[:save_for_later_couples].exists?(target_couple_id: object.target_couple_id)
  end

  def save_for_later_expiration
    @instance_options[:save_for_later_couples] &&
      @instance_options[:save_for_later_couples].find_by(target_couple_id: object.target_couple_id)&.action_expiration
  end

  belongs_to :target_couple, serializer: Api::V1::CoupleProfileSerializer
end
