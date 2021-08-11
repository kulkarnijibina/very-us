class SuggestActivity < ApplicationRecord
  belongs_to :user
  validates :name, presence: true


  BROWSE  = [:user_id, :name].freeze

  ALL_OPTIONS = {
    'Browse' => BROWSE
  }.freeze

  class << self
    def configuration
      active.first
    end

    def get_label(field)
      I18n.t("models.suggest_activity.label.#{field}")
    end
  end
end
