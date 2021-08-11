class Api::V1::BurnCoinsFeatureSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :coins
end
