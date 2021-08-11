class AddDateToMatches < ActiveRecord::Migration[5.2]
  def change
    add_column :matches, :date, :date
  end
end
