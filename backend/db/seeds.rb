# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "🌱 Seeding database..."

Book.destroy_all
Borrower.destroy_all

# Seed Books
books = [
  { title: "The Pragmatic Programmer", isbn: "978-0201616224", stock: 5 },
  { title: "Clean Code", isbn: "978-0132350884", stock: 3 },
  { title: "Design Patterns", isbn: "978-0201633610", stock: 4 },
  { title: "Refactoring", isbn: "978-0201485677", stock: 2 },
  { title: "You Don’t Know JS", isbn: "978-1491904244", stock: 6 }
]

books.each do |book|
  Book.create!(book)
end

# Seed Borrowers
borrowers = [
  { card_number: "ID1001", name: "Alice Johnson", email: "alice@example.com" },
  { card_number: "ID1002", name: "Bob Smith", email: "bob@example.com" },
  { card_number: "ID1003", name: "Charlie Brown", email: "charlie@example.com" },
  { card_number: "ID1004", name: "Diana Prince", email: "diana@example.com" },
  { card_number: "ID1005", name: "Ethan Hunt", email: "ethan@example.com" }
]

borrowers.each do |borrower|
  Borrower.create!(borrower)
end

puts "✅ Seeding done!"