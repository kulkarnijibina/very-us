ActiveAdmin.register SplashScreen do
  permit_params :title, :text1, :text2, :text3, :background_color, :priority, splash_screen_images_attributes: [ :id, :image ]

  config.sort_order = 'priority_desc'

  index do
    selectable_column
    id_column
    column :title
    column :text1
    column :text2
    column :text3
    column :background_color
    column :priority
    column :image do |object|
      image_tag(object.splash_screen_images.first.image, class: "admin_splash_img_small") if object.splash_screen_images.first
    end
    actions
  end

  show do |splash_screen|
    attributes_table do
      row :title
      row :text1
      row :text2
      row :text3
      panel "Splash Screen Images" do
        table_for splash_screen.splash_screen_images do
          column :images do |splash_screen_image|
            image_tag(splash_screen_image.image)
          end
        end
      end
      row :background_color
      row :priority
      row :created_at
      row :updated_at
    end
  end

  filter :title
  filter :text1
  filter :text2
  filter :text3
  filter :priority
  filter :background_color
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      f.input :title
      f.input :text1
      f.input :text2
      f.input :text3
      f.input :background_color
      f.input :priority
      f.has_many :splash_screen_images do |form|
        form.input :image, as: :file, hint: form.object.image.attached? ? image_tag(form.object.image.service_url, class: "admin_splash_img_small") : ""
      end
    end
    f.actions
  end
end
