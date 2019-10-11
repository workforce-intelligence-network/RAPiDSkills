FactoryBot.define do
  factory :occupation_standard_work_process do
    occupation_standard
    work_process
    hours { 10 }
  end
end
