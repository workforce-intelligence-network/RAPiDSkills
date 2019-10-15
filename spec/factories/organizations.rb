FactoryBot.define do
  factory :organization do
    type { "" }
    sequence(:title) { |n| "Org Title #{n}" }
    logo_url { "http://www.example.com" }
    registers_standards { false }
  end
end
