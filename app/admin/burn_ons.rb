ActiveAdmin.register BurnOn do
  permit_params :refresh_match_list, :refresh_matches_count, :per_save_for_later, :per_save_for_later_duration_in_days, :spotlight_duration_in_mins, :change_preference, :change_geography, :incognito_mode, :incognito_duration_in_mins, :spotlight_focus, :edit_tags_on_match_list, :near_by_location_in_km, :status

  scope :active, default: true
  scope :inactive

  actions :all, except: [:show]
  config.filters = false

  index do
    id_column
    BurnOn::ALL_OPTIONS.each do |label,fields|
      column label do |eo|
        attributes_table_for eo do
          fields.each do |field|
            row BurnOn.get_label(field),class: "table_border" do |bo|
              bo.send(field)
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

    BurnOn::ALL_OPTIONS.each do |label,fields|
      f.inputs label do
        fields.each do |field|
          f.input field, label: BurnOn.get_label(field)
        end
      end
    end

    f.inputs :status

    f.actions         # adds the 'Submit' and 'Cancel' buttons
  end
end
