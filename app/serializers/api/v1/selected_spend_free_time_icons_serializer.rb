class Api::V1::SelectedSpendFreeTimeIconsSerializer < ActiveModel::Serializer
  attributes :id, :name, :selected_icon_url

  def selected_icon_url
    object.selected_icon.service_url if object.selected_icon.attached?
  end
end
