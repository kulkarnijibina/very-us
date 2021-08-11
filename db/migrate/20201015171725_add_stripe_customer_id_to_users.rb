class AddStripeCustomerIdToUsers < ActiveRecord::Migration[5.2]
  def change
  	add_column :users, :stripe_customer_id, :string
  	add_column :users, :stripe_card_id, :string
  	add_column :users, :is_card_details_exists, :boolean, default: false
  end
end
