FactoryBot.define do
  factory :state do
    sequence(:short_name) { |n| "abbr#{n}" }
    sequence(:long_name) { |n| "state_name#{n}" }
  end
end
