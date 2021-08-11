class CreateSplashScreenImages < ActiveRecord::Migration[5.2]
  def change
    create_table :splash_screen_images do |t|
      t.references :imageable, polymorphic: true
      t.integer :height
      t.integer :width

      t.timestamps
    end
  end
end
