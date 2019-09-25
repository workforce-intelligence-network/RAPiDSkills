FactoryBot.define do
  factory :location do
    organization
    state
    street_address { Faker::Address.street_address }
    city { Faker::Address.city }
    zip_code { Faker::Address.zip_code }
  end
end
