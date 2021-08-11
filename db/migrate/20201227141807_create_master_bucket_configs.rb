class CreateMasterBucketConfigs < ActiveRecord::Migration[5.2]
  def change
    create_table :master_bucket_configs do |t|
      t.jsonb :match_count_for_day
      t.integer :status

      t.timestamps
    end

    reversible do |dir|
      dir.up do
        MasterBucketConfig.reset_column_information
        MasterBucketConfig.active.first_or_create
      end
    end
  end
end
