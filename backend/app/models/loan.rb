class Loan < ApplicationRecord
  belongs_to :borrower
  belongs_to :book

  validates :borrow_date, :return_date, presence: true
  validate :no_concurrent_loans, on: :create
  validate :stock_available, on: :create
  validate :loan_duration_limit

  before_validation :set_borrow_date, on: :create

  private

  def set_borrow_date
    self.borrow_date ||= Date.today
  end

  # Borrower cannot have another ongoing loan
  def no_concurrent_loans
    if borrower.loans.where(returned_at: nil).exists?
      errors.add(:borrower, "already has an active loan")
    end
  end

  # Ensure stock is available
  def stock_available
    if book.stock <= 0
      errors.add(:book, "is out of stock")
    end
  end

  # Limit loan duration to 30 days max
  def loan_duration_limit
    if borrow_date.present? && return_date.present? &&
       return_date > borrow_date + 30.days
      errors.add(:return_date, "cannot be more than 30 days after the borrow date")
    end
  end
end