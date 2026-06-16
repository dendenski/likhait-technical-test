class Expense < ApplicationRecord
  belongs_to :category

  validate :validate_date

  def validate_date
    return if date.blank?

    if date > Date.today
      errors.add(:date, "cannot be in the future")
    end
  end
end
