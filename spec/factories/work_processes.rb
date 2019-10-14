FactoryBot.define do
  factory :work_process do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
  end
end
