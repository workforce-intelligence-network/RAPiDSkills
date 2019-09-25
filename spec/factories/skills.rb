FactoryBot.define do
  factory :skill do
    description { Faker::Job.key_skill }
    work_process
  end
end
