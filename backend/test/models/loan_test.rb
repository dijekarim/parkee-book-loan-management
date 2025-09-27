require "test_helper"

RSpec.describe Loan, type: :model do
  it "is valid with valid attributes" do
    loan = build(:loan)
    expect(loan).to be_valid
  end

  it "is invalid without a borrow date" do
    loan = build(:loan, borrow_date: nil)
    expect(loan).to be_invalid
    expect(loan.errors.full_messages).to include("Borrow date can't be blank")
  end

  it "is invalid without a return date" do
    loan = build(:loan, return_date: nil)
    expect(loan).to be_invalid
    expect(loan.errors.full_messages).to include("Return date can't be blank")
  end

  it "is invalid if the borrower has an active loan" do
    borrower = create(:borrower)
    create(:loan, borrower: borrower, return_date: nil)
    loan = build(:loan, borrower: borrower)
    expect(loan).to be_invalid
    expect(loan.errors.full_messages).to include("Borrower already has an active loan")
  end

  it "is invalid if the book is out of stock" do
    book = create(:book, stock: 0)
    loan = build(:loan, book: book)
    expect(loan).to be_invalid
    expect(loan.errors.full_messages).to include("Book is out of stock")
  end

  it "is invalid if the return date is more than 30 days after the borrow date" do
    loan = build(:loan, return_date: Faker::Date.between(from: 31.days.from_now, to: 60.days.from_now))
    expect(loan).to be_invalid
    expect(loan.errors.full_messages).to include("Return date cannot be more than 30 days after the borrow date")
  end
end
