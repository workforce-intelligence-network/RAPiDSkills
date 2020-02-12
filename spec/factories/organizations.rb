FactoryBot.define do
  factory :organization do
    type { "" }
    sequence(:title) { |n| "Org Title #{n}" }
    registers_standards { false }
    logo { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'acme-co.jpg'), 'image/jpg') }
  end
end
