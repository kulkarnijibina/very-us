class Api::V1::ApplicationConfigSerializer < ActiveModel::Serializer
  attributes :id, :admin_contact_email,:status, :irrelevant_match_reasons, :report_couple_reasons

  def irrelevant_match_reasons
    object.irrelevant_match_reasons.split("\n").map(&:chomp).reject(&:blank?)
  end

  def report_couple_reasons
    object.serialize_report_couple_reasons
  end
end
