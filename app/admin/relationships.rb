ActiveAdmin.register Relationship do
  scope :is_reported, default: true
  scope :is_irrelevant_match
  actions :index


  filter :created_at

  index do
    id_column
    column :source_couple
    column :target_couple
    column :action
    column :reason
    column :created_at
  end
end
