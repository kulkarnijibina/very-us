class CreateBurnOns < ActiveRecord::Migration[5.2]
  def change
    create_table :burn_ons do |t|
      t.decimal :refresh_match_list
      t.decimal :per_save_for_later
      t.decimal :change_preference
      t.decimal :change_geography
      t.decimal :incognito_mode
      t.decimal :spotlight_focus
      t.decimal :edit_tags_on_match_list
      t.integer :status

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        BurnOn.reset_column_information
        BurnOn.active.first_or_create
      end
    end
  end
end
