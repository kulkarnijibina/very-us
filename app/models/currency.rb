class Currency < ApplicationRecord
  # validations
  validates :name, presence: true
  validates :code, presence: true, uniqueness: {case_sensitive: false}
end
