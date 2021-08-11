class CreatePersonalityTraitsIcons < ActiveRecord::Migration[5.2]
  def change
    create_table :personality_traits_icons do |t|
      t.string :name

      t.timestamps
    end
  end
end
