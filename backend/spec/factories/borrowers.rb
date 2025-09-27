FactoryBot.define do
  factory :borrower do
    name { Faker::Name.name }
    email { Faker::Internet.email }
  end
end
