ActiveAdmin.register LocationConfig do
  permit_params :default_latitude, :default_longitude, :status


  scope :active, default: true
  scope :inactive

  config.filters = false
end
