FactoryBot.define do
  factory :occupation_standard do
    type { "FrameworkStandard" }
    organization
    association :creator, factory: :user
    occupation
    data_trust_approval { false }
    completed_at { Time.current }
    published_at { Time.current }
  end
end
