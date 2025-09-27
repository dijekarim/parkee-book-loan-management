FactoryBot.define do
  today = Date.today
  factory :loan do
    association :book
    association :borrower
    borrow_date { Faker::Date.between(from: 1.week.ago, to: today) }
    return_date { Faker::Date.between(from: today + 1.day, to: today + 1.week) }
  end
end
