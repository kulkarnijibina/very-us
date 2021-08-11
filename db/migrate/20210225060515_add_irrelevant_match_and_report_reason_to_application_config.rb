class AddIrrelevantMatchAndReportReasonToApplicationConfig < ActiveRecord::Migration[5.2]
  def change
    add_column :application_configs, :irrelevant_match_reasons, :text
    add_column :application_configs, :report_couple_reasons, :text
  end
end
