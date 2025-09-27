class Book < ApplicationRecord
  has_many :loans
  has_many :borrowers, through: :loans

  validates :title, :isbn, :stock, presence: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.search(search = nil)
    where("LOWER(title) ILIKE :search OR LOWER(isbn) ILIKE :search", search: "%#{search&.downcase}%")
  end
end
