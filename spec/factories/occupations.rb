FactoryBot.define do
  factory :occupation, class: 'HybridOccupation' do
    type { "HybridOccupation" }
    rapids_code { "MyString" }
    onet_code { "MyString" }
    onet_page_url { "MyString" }
    term_length_min { 1 }
    term_length_max { 1 }
    title_aliases { "" }
  end
end
