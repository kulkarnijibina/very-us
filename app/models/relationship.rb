class Relationship < ApplicationRecord
  enum action: {save_for_later: "save_for_later", block: "block",is_irrelevant_match: "is_irrelevant_match",is_reported: "is_reported"}
  belongs_to :source_couple, class_name: "CoupleProfile", foreign_key: "source_couple_id"
  belongs_to :target_couple, class_name: "CoupleProfile",foreign_key: "target_couple_id"
  
  validates :reason,presence: true, if: -> { is_irrelevant_match? || is_reported? }
  validates :target_couple_id, uniqueness: { scope: [:source_couple_id, :action], message: "Action already performed on this couple."}
 
  def self.is_blocked(source_couple, target_couple)
  	relationship = Relationship.where(source_couple_id: source_couple, target_couple_id: target_couple, action: 'block' ).or(Relationship.where(source_couple_id: target_couple, target_couple_id: source_couple, action: 'block'))
    relationship.present? ? relationship.first.source_couple_id : nil
  end

end
