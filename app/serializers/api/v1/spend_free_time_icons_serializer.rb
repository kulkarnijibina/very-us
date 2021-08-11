class Api::V1::SpendFreeTimeIconsSerializer < ActiveModel::Serializer
  attributes :id, :name, :unselected_icon_url, :selected_icon_url

  def unselected_icon_url
    object.unselected_icon.service_url if object.unselected_icon.attached?
  end

  def selected_icon_url
    object.selected_icon.service_url if object.selected_icon.attached?
  end

end
