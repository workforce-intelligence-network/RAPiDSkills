FactoryBot.define do
  factory :data_import do
    file { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.csv'), 'text/csv') }
    description { Faker::Lorem.sentence }
    kind { 0 }
    user

    after(:build) do |job|
      class << job
        def run_import; true; end
      end
    end
  end
end
