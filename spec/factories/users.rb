FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "supersecret" }
    name { Faker::Name.name }

    factory :admin do
      role { :admin }
    end
  end
end
