class CreateBanners < ActiveRecord::Migration[5.2]
  def change
    create_table :banners do |t|
      t.string :name
      t.string :title
      t.string :description

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        AddBannersService.call
      end
    end
    
  end
end
