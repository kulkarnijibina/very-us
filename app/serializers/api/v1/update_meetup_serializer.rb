# frozen_string_literal: true

class Api::V1::UpdateMeetupSerializer < ActiveModel::Serializer
  attributes :id, :status, :date_time, :location, :description, :source_couple_id, :target_couple_id, :target_couple_name, :created_at, :updated_at, :source_couple_profile_image, :target_couple_profile_image

  def target_couple_name
  	object.recipient.name if object.recipient.present? and object.recipient.name.present?
  end

  def source_couple_profile_image
  	Api::V1::ImageSerializer.new(object.sender.profile_pic) if object.sender.present? and object.sender.profile_pic.present?
  end

  def target_couple_profile_image
  	Api::V1::ImageSerializer.new(object.recipient.profile_pic) if object.recipient.present? and object.recipient.profile_pic.present? 
  end
end
