ActiveAdmin.register Transaction do

  actions :index, :show
  config.filters = true

  index do
    selectable_column
    id_column
    column :amount
    column :transaction_type
    column :transaction_purpose
    column :payment
    column :couple_profile
    column :created_at
    actions
  end

  filter :transaction_type, as: :select, collection: Transaction.transaction_types
  filter :transaction_purpose, as: :select, collection: Transaction.select(:transaction_purpose).distinct.pluck(:transaction_purpose).compact
  filter :amount
  filter :created_at

  show do |transaction|
    attributes_table do
      row :amount
      row :description
      row :status
      row :payment
      row :transaction_type
      row :transaction_purpose
      row :couple_profile
      row :created_at
      row :updated_at
    end
  end

end
