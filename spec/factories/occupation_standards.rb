FactoryBot.define do
  factory :occupation_standard, class: 'FrameworkStandard'  do
    type { "FrameworkStandard" }
    title { Faker::Job.title }
    organization
    association :creator, factory: :user
    occupation
    data_trust_approval { false }

    trait :with_pdf do
      pdf { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'pixel1x1.pdf'), 'application/pdf') }
    end

    trait :with_excel do
      excel { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test.csv'), 'text/csv') }
    end
  end
end
