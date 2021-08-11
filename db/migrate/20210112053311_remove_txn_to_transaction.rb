class RemoveTxnToTransaction < ActiveRecord::Migration[5.2]
  def change
  	remove_column :transactions, :txn_id 
  	remove_column :transactions, :user_remark
  end
end
