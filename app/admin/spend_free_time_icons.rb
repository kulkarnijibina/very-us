ActiveAdmin.register SpendFreeTimeIcon do
permit_params :name, :unselected_icon, :selected_icon
  index do
    selectable_column
    id_column
    column :name
    column :unselected_icon do |spend_free_time_icon|
      image_tag(spend_free_time_icon.unselected_icon, class: "admin_icon")
    end
    column :selected_icon do |spend_free_time_icon|
      image_tag(spend_free_time_icon.selected_icon, class: "admin_icon")
    end
    column :created_at
    actions
  end

  show do |spend_free_time_icon|
    attributes_table do
      row :name
      row :unselected_icon do
        image_tag(spend_free_time_icon.unselected_icon)
      end
      row :selected_icon do
        image_tag(spend_free_time_icon.selected_icon)
      end
      row :created_at
      row :updated_at
    end
  end

  filter :name
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :name
      f.input :unselected_icon, as: :file, hint: f.object.unselected_icon.attached? ? image_tag(f.object.unselected_icon.service_url, class: "admin_splash_img_small") : ""
      f.input :selected_icon, as: :file, hint: f.object.selected_icon.attached? ? image_tag(f.object.selected_icon.service_url, class: "admin_splash_img_small") : ""
    end
    f.actions
  end
end
