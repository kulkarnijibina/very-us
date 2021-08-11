ActiveAdmin.register EarnOn do
  permit_params *EarnOn::ALL_OPTIONS.values.flatten.push(:status)

  scope :active, default: true
  scope :inactive

  actions :all, except: [:show]

  config.filters = false

  index do
    id_column
    EarnOn::ALL_OPTIONS.each do |label,fields|
      column label do |eo|
        attributes_table_for eo do
          fields.each do |field|
            row EarnOn.get_label(field), class: "table_border" do
              eo.send(field)
            end
          end
        end
        nil
      end
    end

    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors # shows errors on :base

    EarnOn::ALL_OPTIONS.each do |label,fields|
      f.inputs label do
        fields.each do |field|
          f.input field, label: EarnOn.get_label(field)
        end
      end
    end

    f.inputs :status

    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
