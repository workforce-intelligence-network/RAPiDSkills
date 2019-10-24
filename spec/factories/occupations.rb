FactoryBot.define do
  factory :occupation, class: 'HybridOccupation' do
    type { "HybridOccupation" }
    sequence(:rapids_code) {|n| "code#{n}" }
    onet_code { Faker::Lorem.characters(number: 6) }
    onet_page_url { "http://www.example.com" }
    term_length_min { 1 }
    term_length_max { 1 }
    title_aliases { "" }
  end
end
