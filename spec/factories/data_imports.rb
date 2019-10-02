FactoryBot.define do
  factory :data_import do
    description { Faker::Lorem.sentence }
    kind { 0 }
  end
end
