FactoryBot.define do
  factory :data_import do
    file { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.csv'), 'text/csv') }
    description { Faker::Lorem.sentence }
    kind { 0 }
  end
end
