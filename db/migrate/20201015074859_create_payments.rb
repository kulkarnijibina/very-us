class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
    	t.integer :user_id
    	t.string  :stripe_charge_id
    	t.string  :status
    	t.decimal :amount
      t.timestamps
    end
  end
end
