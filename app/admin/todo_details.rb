ActiveAdmin.register TodoDetail do
permit_params :name, :description, :image,:title
  index do
    selectable_column
    id_column
    column :name
    column :title
    column :description
    column :image do |todo_detail|
      image_tag(todo_detail.image, class: "admin_icon") if todo_detail.image.attached?
    end
    column :created_at
    actions
  end

  show do |todo_detail|
    attributes_table do
      row :name
      row :title
      row :description
      row :image do
        image_tag(todo_detail.image) if todo_detail.image.attached?
      end
      row :created_at
      row :updated_at
    end
  end

  filter :name
  filter :title
  filter :description
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.input :name, as: :select, collection: TodoDetail.names.keys, selected: f.object.name || TodoDetail.names[:complete_your_profile]
      f.input :title
      f.input :description
      f.input :image, as: :file, hint: f.object.image.attached? ? image_tag(f.object.image.service_url, class: "admin_splash_img_small") : ""
    end
    f.actions
  end
end
