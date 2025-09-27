require "rails_helper"

RSpec.describe Book, type: :model do
  it "is valid with valid attributes" do
    book = build(:book)
    expect(book).to be_valid
  end

  it "is invalid with negative stock" do
    book = build(:book, stock: -1)
    expect(book).to be_invalid
    expect(book.errors.full_messages).to include("Stock must be greater than or equal to 0")
  end
end
