class Api::V1::DashboardController < ApplicationController
  include Pagy::Backend

  def index
    books_count     = Book.count
    total_stock     = Book.sum(:stock)
    borrowers_count = Borrower.count

    active_loans    = Loan.where(returned_at: nil).where("return_date >= ?", Date.today).count
    overdue_loans_c = Loan.where(returned_at: nil).where("return_date < ?", Date.today).count
    returned_loans  = Loan.where.not(returned_at: nil).count

    recent_loans = Loan.includes(:borrower, :book)
                       .order(created_at: :desc)
                       .limit(5)
                       .map { |loan| loan_json(loan) }

    overdue_loans_list = Loan.includes(:borrower, :book)
                             .where(returned_at: nil)
                             .where("return_date < ?", Date.today)
                             .order(return_date: :asc)
                             .limit(5)
                             .map do |loan|
      {
        id: loan.id,
        borrower: { id: loan.borrower.id, name: loan.borrower.name },
        book: { id: loan.book.id, title: loan.book.title },
        return_date: loan.return_date
      }
    end

    render json: {
      books: books_count,
      total_stock: total_stock,
      borrowers: borrowers_count,
      active_loans: active_loans,
      overdue_loans: overdue_loans_c,
      returned_loans: returned_loans,
      recent_loans: recent_loans,
      overdue_loans_list: overdue_loans_list
    }
  end

  private

  def loan_json(loan)
    {
      id: loan.id,
      borrower: { id: loan.borrower.id, name: loan.borrower.name },
      book: { id: loan.book.id, title: loan.book.title },
      borrow_date: loan.borrow_date,
      return_date: loan.return_date,
      status: loan_status(loan)
    }
  end

  def loan_status(loan)
    if loan.returned_at.present?
      "Returned"
    elsif loan.return_date < Date.today
      "Overdue"
    else
      "Active"
    end
  end
end