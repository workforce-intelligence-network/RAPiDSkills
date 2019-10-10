FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "supersecret" }
    name { "MyString" }

    factory :admin do
      role { :admin }
    end
  end
end
