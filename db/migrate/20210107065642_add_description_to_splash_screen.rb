class AddDescriptionToSplashScreen < ActiveRecord::Migration[5.2]
  def change
    add_column :splash_screens, :description, :string
  end
end
