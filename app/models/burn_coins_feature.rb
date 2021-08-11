class BurnCoinsFeature < ApplicationRecord
  validates :name, :description, :coins, presence: true
end
