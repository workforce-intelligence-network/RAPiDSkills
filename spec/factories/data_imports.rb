FactoryBot.define do
  factory :data_import do
    description { Faker::Lorem.sentence }
    kind { 1 }
  end
end
