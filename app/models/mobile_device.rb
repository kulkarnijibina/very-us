class MobileDevice < ApplicationRecord
  validates :device_id, presence: true
  belongs_to :user
end
