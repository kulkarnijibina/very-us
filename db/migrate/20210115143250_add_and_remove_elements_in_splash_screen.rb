class AddAndRemoveElementsInSplashScreen < ActiveRecord::Migration[5.2]
  def change
    rename_column :splash_screens, :text, :title
    rename_column :splash_screens, :description, :text1
    add_column :splash_screens, :text2, :string
    add_column :splash_screens, :text3, :string
    add_column :splash_screens, :priority, :integer
    add_column :splash_screens, :background_color, :string
  end
end
