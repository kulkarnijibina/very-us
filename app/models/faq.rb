class Faq < ApplicationRecord
  validates :question, :answer, presence: true
end
