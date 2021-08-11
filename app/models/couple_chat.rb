class CoupleChat < ApplicationRecord
  belongs_to :chat 
  belongs_to :couple_profile
end
