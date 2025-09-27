class Borrower < ApplicationRecord
  has_many :loans
  has_many :books, through: :loans

  validates :name, :email, :card_number, presence: true
  validates :card_number, :email, uniqueness: true

  def self.search(search = nil)
    where("LOWER(name) ILIKE :search OR LOWER(email) ILIKE :search OR LOWER(card_number) ILIKE :search", search: "%#{search&.downcase}%")
  end
end
