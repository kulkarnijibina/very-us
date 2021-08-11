class CreateJwtAllowLists < ActiveRecord::Migration[5.2]
  def change
    create_table :jwt_allow_lists do |t|
      t.string :jti, null: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end
  end
end
