class ChangeFieldsInBuckets < ActiveRecord::Migration[5.2]
  def change
    rename_column :buckets, :percentage, :threshold_percentage
    remove_column :buckets, :match_count_for_day, :text
    add_column :buckets, :percentage_for_day, :jsonb
  end
end
