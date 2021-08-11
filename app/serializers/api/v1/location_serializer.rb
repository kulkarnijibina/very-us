class Api::V1::LocationSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude
end
