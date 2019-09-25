FactoryBot.define do
  factory :industry do
    title { Faker::Company.industry }
    naics_code { Faker::Lorem.characters(number: 8) }
  end
end
