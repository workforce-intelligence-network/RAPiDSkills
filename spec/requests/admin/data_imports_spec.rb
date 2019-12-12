require 'rails_helper'

RSpec.describe "Admin::DataImports", type: :request do
  describe "POST #create" do
    let(:path) { admin_data_imports_path }
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }
    let(:params) {
      {
        data_import: {
          file: file,
          user_id: user.id,
          kind: "occupation_standards",
          description: "this is a description",
        }
      }
    }

    before { sign_in admin }

    context "occupation_standards upload" do
      context "with valid data" do
        context "with rapids_code" do
          let!(:state) { create(:state, short_name: "CA") }
          let!(:occupation) { create(:occupation, rapids_code: "1039HY", title: "Dog Training") }
          let(:file) { fixture_file_upload("files/dog_walking.csv", "text/csv") }

          it "saves data correctly" do
            expect{
              post path, params: params
            }.to change(DataImport, :count).by(1)
              .and change(OccupationStandard, :count).by(2)
              .and change(WorkProcess, :count).by(3)
              .and change(Skill, :count).by(5)
              .and change(OccupationStandardWorkProcess, :count).by(3)
              .and change(OccupationStandardSkill, :count).by(5)
              .and change(Organization, :count).by(1)

            di = DataImport.last
            expect(di.user).to eq user
            expect(di.description).to eq "this is a description"
            expect(di.occupation_standards?).to be true

            organization = Organization.last
            expect(organization.title).to eq "Acme Dog Walking"

            os1 = OccupationStandard.first
            expect(os1.title).to eq "Heeling"
            expect(os1.occupation).to eq occupation
            expect(os1.organization).to eq organization
            expect(os1.creator).to eq user
            expect(os1.type).to eq "FrameworkStandard"
            expect(os1.registration_organization_name).to eq "CA Dept of Labor"
            expect(os1.registration_state).to eq state

            expect(os1.work_processes[0].title).to eq "Communicate effectively"
            expect(os1.work_processes[0].description).to eq "Communicate effectively with dog and human"
            expect(os1.occupation_standard_work_processes[0].hours).to eq 60
            expect(os1.work_processes[1].title).to eq "Dealing with other dogs"
            expect(os1.work_processes[1].description).to eq "Handle interactions with other dogs"
            expect(os1.occupation_standard_work_processes[1].hours).to eq 100

            expect(os1.flattened_skills[0].description).to eq "Communicate with dog"
            expect(os1.flattened_skills[1].description).to eq "Communicate with human"
            expect(os1.flattened_skills[2].description).to eq "Demonstrate ability to walk by aggressive dogs"
            expect(os1.flattened_skills[3].description).to eq "Demonstrate ability to cross intersection"
            expect(os1.occupation_standard_skills[0].occupation_standard_work_process).to eq os1.occupation_standard_work_processes[0]
            expect(os1.occupation_standard_skills[1].occupation_standard_work_process).to eq os1.occupation_standard_work_processes[0]
            expect(os1.occupation_standard_skills[2].occupation_standard_work_process).to eq os1.occupation_standard_work_processes[1]
            expect(os1.occupation_standard_skills[3].occupation_standard_work_process).to eq os1.occupation_standard_work_processes[1]

            os2 = OccupationStandard.last
            expect(os2.title).to eq "Dog Training"
            expect(os2.occupation).to eq occupation
            expect(os2.organization).to eq organization
            expect(os2.creator).to eq user
            expect(os2.type).to eq "UnregisteredStandard"

            expect(os2.work_processes[0].title).to eq "Billing"
            expect(os2.work_processes[0].description).to eq "Bill for services"
            expect(os2.occupation_standard_work_processes[0].hours).to eq 50

            expect(os2.flattened_skills[0].description).to eq "Understand costs"
            expect(os2.occupation_standard_skills[0].occupation_standard_work_process).to eq os2.occupation_standard_work_processes[0]
          end
        end

        context "without rapids_code" do
          let(:file) { fixture_file_upload("files/hcap.csv", "text/csv") }
          let!(:occupation1) { create(:occupation, title: "addictions counselor") }
          let!(:occupation2) { create(:occupation, onet_code: "0569CB") }

          it "saves data correctly" do
            expect{
              post path, params: params
            }.to change(DataImport, :count).by(1)
              .and change(Occupation, :count).by(1)
              .and change(OccupationStandard, :count).by(3)
              .and change(WorkProcess, :count).by(2)
              .and change(Skill, :count).by(6)
              .and change(OccupationStandardWorkProcess, :count).by(2)
              .and change(OccupationStandardSkill, :count).by(6)
              .and change(Organization, :count).by(3)

            di = DataImport.last
            expect(di.user).to eq user
            expect(di.description).to eq "this is a description"
            expect(di.occupation_standards?).to be true

            occupation = Occupation.last
            expect(occupation.title).to eq "Central Sterile Processing Technician"
            expect(occupation.rapids_code).to be_blank
            expect(occupation.onet_code).to be_blank
            expect(occupation).to be_a(CompetencyOccupation)
          end
        end
      end

      context "with invalid data" do
        context "with partial invalid data" do
          let(:file) { fixture_file_upload("files/data_import_invalid_row.csv", "text/csv") }

          it "imports all but bad data" do
            expect{
              post path, params: params
            }.to change(DataImport, :count).by(1)
              .and change(OccupationStandard, :count).by(1)
              .and change(WorkProcess, :count).by(2)
              .and change(Skill, :count).by(4)
              .and change(OccupationStandardWorkProcess, :count).by(2)
              .and change(OccupationStandardSkill, :count).by(4)
          end
        end

        context "with complete invalid data" do
          let(:file) { fixture_file_upload("files/bad_occupation_type.csv", "text/csv") }
          it "does not import bad data" do
            expect{
              post path, params: params
            }.to change(DataImport, :count).by(0)
              .and change(OccupationStandard, :count).by(0)
              .and change(WorkProcess, :count).by(0)
              .and change(Skill, :count).by(0)
              .and change(OccupationStandardWorkProcess, :count).by(0)
              .and change(OccupationStandardSkill, :count).by(0)
          end
        end
      end
    end
  end
end
