ActiveAdmin.register Banner, as: 'Todo Banners' do
permit_params :name, :description, :image
  index do
    selectable_column
    id_column
    column :name
    column :title
    column :description
    column :image do |banner|
      image_tag(banner.image, class: "admin_icon") if banner.image.attached?
    end
    column :created_at
    actions
  end

  show do |banner|
    attributes_table do
      row :name
      row :title
      row :description
      row :image do
        image_tag(banner.image) if banner.image.attached?
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
      f.input :name, as: :select, collection: Banner.names.keys, selected: f.object.name || Banner.names[:post_on_social_media]
      f.input :title
      f.input :description
      f.input :image, as: :file
    end
    f.actions
  end
end
