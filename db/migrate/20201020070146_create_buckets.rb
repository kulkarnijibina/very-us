class CreateBuckets < ActiveRecord::Migration[5.2]
  def change
    create_table :buckets do |t|
      t.float :percentage
      t.text :match_count_for_day

      t.timestamps
    end
  end
end
