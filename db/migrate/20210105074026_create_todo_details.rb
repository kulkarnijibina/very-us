class CreateTodoDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :todo_details do |t|
      t.string :name
      t.string :description
      t.string :title

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        AddTodoDetailsService.call
      end
    end

  end
end
