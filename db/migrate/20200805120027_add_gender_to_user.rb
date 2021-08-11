class AddGenderToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :gender, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :drink_or_smoke, :integer
  end
end
