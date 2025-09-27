require "spec_helper"

RSpec.describe Borrower, type: :model do
  it "is valid with valid attributes" do
    borrower = build(:borrower)
    expect(borrower).to be_valid
  end

  it "is invalid without a card number" do
    borrower = build(:borrower, email: nil)
    expect(borrower).to be_invalid
    expect(borrower.errors.full_messages).to include("Email can't be blank")
  end

  it "is invalid with a non-unique card email" do
    create(:borrower, email: "user@example.com")
    borrower = build(:borrower, email: "user@example.com")
    expect(borrower).to be_invalid
    expect(borrower.errors.full_messages).to include("Email has already been taken")
  end
end
