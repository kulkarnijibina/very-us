ActiveAdmin.register Faq do
  permit_params :question, :answer
  index do
    selectable_column
    id_column
    column :question
    column :answer
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :question
      f.input :answer, :as => :text
    end
    f.actions
  end
end