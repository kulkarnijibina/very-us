class CreateSplashScreens < ActiveRecord::Migration[5.2]
  def change
    create_table :splash_screens do |t|
      t.string :text

      t.timestamps
    end
  end
end
