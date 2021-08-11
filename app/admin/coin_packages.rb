ActiveAdmin.register CoinPackage do
  permit_params :title, :amount, :coins
  index do
    selectable_column
    id_column
    column :title
    column :amount
    column :coins
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :title
      f.input :amount
      f.input :coins
    end
    f.actions
  end
end