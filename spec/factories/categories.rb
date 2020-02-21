FactoryBot.define do
  factory :category do
    sequence(:name) {|n| "Category #{n}" }
    occupation_standard_work_process
    sort_order { 1 }
  end
end
