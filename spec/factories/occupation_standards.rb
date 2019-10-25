FactoryBot.define do
  factory :occupation_standard, class: 'FrameworkStandard'  do
    type { "FrameworkStandard" }
    title { Faker::Job.title }
    organization
    association :creator, factory: :user
    occupation
    data_trust_approval { false }
  end
end
