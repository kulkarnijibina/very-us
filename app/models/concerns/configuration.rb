module Configuration
  extend ActiveSupport::Concern

  included do
    # enum
    enum status: %w(active inactive)

    # validation
    validates :status, presence: true
    validate :validate_at_least_one_other_active, unless: :active?

    # callbacks
    after_initialize :set_default_status
    after_save :inactivate_other_records, if: :active?
    before_destroy :prevent_destroy_if_active
  end

  def other_active_records
    self.class.active.where.not(id: self)
  end

  private
  def validate_at_least_one_other_active
    unless other_active_records.exists?
      errors.add(:base, "Any one should be active!")
    end
  end

  def set_default_status
    self.status ||= other_active_records.exists? ? 'inactive' : 'active'
  end

  def inactivate_other_records
    other_active_records.update(status: 'inactive')
  end

  def prevent_destroy_if_active
    if active?
      errors.add(:base, "Can not delete the active entry!")
      throw(:abort)
    end
  end
end
