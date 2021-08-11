ActiveAdmin.register User do

  menu label: 'Users'
  permit_params :first_name, :last_name, :contact

  member_action :deactivate, method: :post do
    user = User.find(params[:id])
    action_name = user.couple_profile.deactivated_by_admin? ? 'Activate' : 'Deactivate'
    if user.couple_profile.deactivated_by_admin?
      user.couple_profile.active!
    else
      user.couple_profile.deactivated_by_admin!
    end
    redirect_to collection_path, notice: "User #{action_name} Successfully!"
  end

  actions :index, :show, :destroy

  filter :first_name
  filter :last_name
  filter :contact

  index do
    selectable_column
    id_column
    column :first_name
    column :last_name
    column :contact
    column :country_code
    column :gender
    column :date_of_birth
    column :language
    column :orientation
    column :smoke
    column :drink
    column :occupation
    column :status do |user|
      user.couple_profile.status.humanize
    end
    column :created_at
    actions defaults: true do |user|
      item link_to('View Couple Profile', [:admin, user.couple_profile]) if user.couple_profile
    end
    actions defaults: false do |user|
      action_name = !user.couple_profile.deactivated_by_admin? ? 'Deactivate' : 'Activate'
      item link_to(action_name, deactivate_admin_user_path(user), method: :post) if user.couple_profile
    end
  end

  show do |user|
    attributes_table do
      row :first_name
      row :last_name
      row :country_code
      row :contact
      row :gender
      row :date_of_birth
      row :language
      row :smoke
      row :drink
      row :occupation
      row :orientation
      row :linkedin_verified
      row :facebook_verified
      row :instagram_verified
      row :device_id do |obj|
        obj.mobile_devices.first&.device_id
      end
    end
  end

  form do |f|
    inputs 'Users'do
      f.input :first_name
      f.input :last_name
      f.input :contact
    end
    actions
  end
end
