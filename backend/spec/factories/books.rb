FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    isbn { Faker::Code.isbn }
    stock { Faker::Number.between(from: 1, to: 10) }
  end
end
