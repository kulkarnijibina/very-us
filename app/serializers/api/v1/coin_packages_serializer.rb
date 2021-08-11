class Api::V1::CoinPackagesSerializer < ActiveModel::Serializer
  attributes :id, :title, :amount, :coins
end
