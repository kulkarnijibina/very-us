# frozen_string_literal: true

class Api::V1::UserSerializer < ActiveModel::Serializer
  attributes :id,
             :first_name,
             :last_name,
             :contact,
             :date_of_birth,
             :drink,
             :smoke,
             :occupation,
             :gender,
             :language,
             :orientation
end
