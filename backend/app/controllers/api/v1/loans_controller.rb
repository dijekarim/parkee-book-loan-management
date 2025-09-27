class Api::V1::LoansController < ApplicationController
  include Pagy::Backend
  before_action :set_loan, only: [:return]

  # GET /loans
  def index
    pagy, loans = pagy(Loan.includes(:borrower, :book).order(created_at: :desc), items: 20)

    loans_data = loans.map do |loan|
      {
        id: loan.id,
        borrower: {
          id: loan.borrower.id,
          name: loan.borrower.name,
          card_number: loan.borrower.card_number
        },
        book: {
          id: loan.book.id,
          title: loan.book.title
        },
        borrow_date: loan.borrow_date,
        return_date: loan.return_date,
        returned_at: loan.returned_at,
        status: loan_status(loan)
      }
    end

    render json: {
      data: loans_data,
      pagination: pagy
    }
  end

  # POST /loans
  def create
    borrower = Borrower.find(params[:borrower_id])
    book = Book.find(params[:book_id])

    if borrower.loans.where(returned_at: nil).exists?
      return render json: { error: "Borrower already has an active loan" }, status: :unprocessable_entity
    end

    if book.stock <= 0
      return render json: { error: "Book out of stock" }, status: :unprocessable_entity
    end

    borrow_date = Date.today
    return_date = Date.parse(params[:return_date])

    if return_date > borrow_date + 30.days
      return render json: { error: "Return date cannot be more than 30 days" }, status: :unprocessable_entity
    end

    loan = Loan.create!(
      borrower: borrower,
      book: book,
      borrow_date: borrow_date,
      return_date: return_date
    )

    book.update!(stock: book.stock - 1)

    render json: loan, status: :created
  end

  # PATCH /loans/:id/return
  def return
    if @loan.returned_at.present?
      return render json: { error: "Loan already returned" }, status: :unprocessable_entity
    end

    @loan.update!(returned_at: Time.current)
    @loan.book.update!(stock: @loan.book.stock + 1)

    render json: { success: true }
  end

  private

  def set_loan
    @loan = Loan.find(params[:id])
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