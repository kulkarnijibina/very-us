class ChangeTypeOfAnswerInFaq < ActiveRecord::Migration[5.2]
  def up
    change_column :faqs, :answer, :text
  end

  def down
    change_column :faqs, :answer, :string
  end
end
