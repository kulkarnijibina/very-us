class AddIrrelavantMatchCounterInCoupleProfile < ActiveRecord::Migration[5.2]
  def change
  	add_column :couple_profiles, :irrelevant_match_counter, :jsonb, default: {}
  end
end
