# frozen_string_literal: true

class Api::V1::CoupleProfileSerializer < ActiveModel::Serializer
  attributes :id,
             :place,
             :anniversary,
             :free_save_for_later_count,
             :orientation,
             :have_children,
             :have_pets,
             :do_for_fun,
             :goals,
             :values_needed,
             :meetup_dates,
             :chat_availability,
             :primary_user,
             :secondary_user,
             :secondary_user_details,
             :partner_number,
             :activities,
             :personality_traits,
             :activities_raw,
             :personality_traits_raw,
             :karma_score,
             :wallet_balance,
             :incognito,
             :location,
             :spotlight_on,
             :images,
             :profile_pic,
             :profile_completed,
             :verified_profile,
             :onboarding_status

  def images
    ActiveModel::Serializer::CollectionSerializer.new(object.images, serializer: Api::V1::ImageSerializer) if object.images
  end

  def activities
    spend_free_time_icons = SpendFreeTimeIcon.where(name: object.activities)
    ActiveModel::Serializer::CollectionSerializer.new(spend_free_time_icons, serializer: Api::V1::SelectedSpendFreeTimeIconsSerializer) if spend_free_time_icons
  end

  def activities_raw
    object.activities
  end

  def personality_traits
    personality_traits = PersonalityTraitsIcon.where(name: object.personality_traits)
    ActiveModel::Serializer::CollectionSerializer.new(personality_traits, serializer: Api::V1::SelectedPersonalityTraitsIconsSerializer) if personality_traits
  end

  def personality_traits_raw
    object.personality_traits
  end

  def location
    Api::V1::LocationSerializer.new(object.location) if object.location
  end

  def profile_pic
    Api::V1::ImageSerializer.new(object.profile_pic) if object.profile_pic
  end

  def secondary_user_details
    object.secondary_user ? object.secondary_user : object.secondary_user_details
  end
end
