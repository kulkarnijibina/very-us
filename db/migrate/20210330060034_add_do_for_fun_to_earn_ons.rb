class AddDoForFunToEarnOns < ActiveRecord::Migration[5.2]
  def change
    add_column :earn_ons, :do_for_fun, :integer
    add_column :earn_ons, :goals, :integer
    add_column :earn_ons, :values_needed, :integer
  end
end
