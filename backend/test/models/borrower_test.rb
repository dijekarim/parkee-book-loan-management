require "test_helper"

RSpec.describe Borrower, type: :model do
  it "is valid with valid attributes" do
    borrower = build(:borrower)
    expect(borrower).to be_valid
  end

  it "is invalid without a card number" do
    borrower = build(:borrower, card_number: nil)
    expect(borrower).to be_invalid
    expect(borrower.errors.full_messages).to include("Card number can't be blank")
  end

  it "is invalid with a non-unique card number" do
    create(:borrower, card_number: "123456789")
    borrower = build(:borrower, card_number: "123456789")
    expect(borrower).to be_invalid
    expect(borrower.errors.full_messages).to include("Card number has already been taken")
  end
end
