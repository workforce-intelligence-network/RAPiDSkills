FactoryBot.define do
  factory :skill do
    description { Faker::Job.key_skill }
  end
end
