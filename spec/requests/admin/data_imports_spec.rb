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
          let!(:occupation2) { create(:occupation, onet_code: "12345", title: "Dog Walking") }
          let(:file) { fixture_file_upload("files/dog_walking.csv", "text/csv") }

          it "saves data correctly" do
            expect{
              post path, params: params
            }.to change(DataImport, :count).by(1)
              .and change(OccupationStandard, :count).by(6)
              .and change(WorkProcess, :count).by(4)
              .and change(Skill, :count).by(8)
              .and change(Category, :count).by(2)
              .and change(OccupationStandardWorkProcess, :count).by(7)
              .and change(OccupationStandardSkill, :count).by(11)
              .and change(Organization, :count).by(3)
              .and change(Occupation, :count).by(1)

            di = DataImport.last
            expect(di.user).to eq user
            expect(di.description).to eq "this is a description"
            expect(di.occupation_standards?).to be true

            organizations = Organization.order(:id)
            organization1 = organizations.first
            expect(organization1.title).to eq "Acme Dog Walking"

            organization2 = organizations[1]
            expect(organization2.title).to eq "Dog Walking R Us"

            organization3 = organizations.last
            expect(organization3.title).to eq "Pet Palace"

            occupation_new = Occupation.last
            expect(occupation_new.title).to eq "Heeling"
            expect(occupation_new.type).to eq "HybridOccupation"
            expect(occupation_new.rapids_code).to be_blank
            expect(occupation_new.onet_code).to be_blank

            occupation_standards = OccupationStandard.order(:id)
            os1 = occupation_standards[0]
            expect(os1.title).to eq "Heeling"
            expect(os1.occupation).to eq occupation
            expect(os1.organization).to eq organization1
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

            os2 = occupation_standards[1]
            expect(os2.title).to eq "Heeling"
            expect(os2.occupation).to eq occupation
            expect(os2.organization).to eq organization2
            expect(os2.creator).to eq user
            expect(os2.type).to eq "FrameworkStandard"

            expect(os2.work_processes[0].title).to eq "Communicate effectively"
            expect(os2.work_processes[0].description).to eq "Communicate effectively with dog and human"
            expect(os2.occupation_standard_work_processes[0].hours).to eq 40

            expect(os2.flattened_skills[0].description).to eq "Communicate with dog"
            expect(os2.occupation_standard_skills[0].occupation_standard_work_process).to eq os2.occupation_standard_work_processes[0]

            os3 = occupation_standards[2]
            expect(os3.title).to eq "Dog Training"
            expect(os3.occupation).to eq occupation
            expect(os3.organization).to eq organization1
            expect(os3.creator).to eq user
            expect(os3.type).to eq "UnregisteredStandard"

            expect(os3.work_processes[0].title).to eq "Billing"
            expect(os3.work_processes[0].description).to eq "Bill for services"
            expect(os3.occupation_standard_work_processes[0].hours).to eq 50

            expect(os3.flattened_skills[0].description).to eq "Understand costs"
            expect(os3.occupation_standard_skills[0].occupation_standard_work_process).to eq os3.occupation_standard_work_processes[0]

            os4 = occupation_standards[3]
            expect(os4.title).to eq "Grooming"
            expect(os4.occupation).to eq occupation
            expect(os4.organization).to eq organization3
            expect(os4.creator).to eq user
            expect(os4.type).to eq "FrameworkStandard"

            expect(os4.work_processes[0].title).to eq "Safety"
            expect(os4.work_processes[0].description).to eq "All safety"
            oswp = os4.occupation_standard_work_processes[0]
            expect(oswp.hours).to eq 10
            expect(oswp.sort_order).to eq 1

            os5 = occupation_standards[4]
            expect(os5.title).to eq "Heeling"
            expect(os5.occupation).to eq occupation2
            expect(os5.organization).to eq organization1
            expect(os5.creator).to eq user
            expect(os5.type).to eq "FrameworkStandard"
            expect(os5.registration_state).to eq state
            expect(os5.registration_organization_name).to eq "CA Dept of Labor"

            expect(os5.work_processes[0].title).to eq "Communicate effectively"
            expect(os5.work_processes[0].description).to eq "Communicate effectively with dog and human"
            expect(os5.occupation_standard_work_processes[0].hours).to eq 35

            expect(os5.flattened_skills[0].description).to eq "Communicate with dog"
            expect(os5.occupation_standard_skills[0].occupation_standard_work_process).to eq os5.occupation_standard_work_processes[0]

            os6 = occupation_standards[5]
            expect(os6.title).to eq "Heeling"
            expect(os6.occupation).to eq occupation_new
            expect(os6.organization).to eq organization1
            expect(os6.creator).to eq user
            expect(os6.type).to eq "FrameworkStandard"
            expect(os6.registration_state).to eq state
            expect(os6.registration_organization_name).to eq "CA Dept of Labor"

            expect(os6.work_processes[0].title).to eq "Communicate effectively"
            expect(os6.work_processes[0].description).to eq "Communicate effectively with dog and human"
            expect(os6.occupation_standard_work_processes[0].hours).to eq 45

            expect(os6.flattened_skills[0].description).to eq "Communicate with dog"
            expect(os6.occupation_standard_skills[0].occupation_standard_work_process).to eq os6.occupation_standard_work_processes[0]

            cat1 = oswp.categories.first
            expect(cat1.name).to eq "Safety procedures"
            expect(cat1.sort_order).to eq 1

            cat2 = oswp.categories.last
            expect(cat2.name).to eq "Safety features"
            expect(cat2.sort_order).to eq 2

            expect(cat1.occupation_standard_skills[0].skill.description).to eq "Handle cat"
            expect(cat1.occupation_standard_skills[0].sort_order).to eq 1
            expect(cat1.occupation_standard_skills[0].occupation_standard_work_process).to eq oswp

            expect(cat1.occupation_standard_skills[1].skill.description).to eq "Handle dog"
            expect(cat1.occupation_standard_skills[1].sort_order).to eq 2
            expect(cat1.occupation_standard_skills[1].occupation_standard_work_process).to eq oswp

            expect(cat2.occupation_standard_skills[0].skill.description).to eq "Restrain animal"
            expect(cat2.occupation_standard_skills[0].sort_order).to eq 3
            expect(cat2.occupation_standard_skills[0].occupation_standard_work_process).to eq oswp
          end

          it "triggers pdf/excel generation" do
            expect(GenerateOccupationStandardPdfJob).to receive(:perform_later).exactly(6).times
            expect(GenerateOccupationStandardExcelJob).to receive(:perform_later).exactly(6).times
            post path, params: params
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

          it "triggers pdf/excel generation" do
            expect(GenerateOccupationStandardPdfJob).to receive(:perform_later).once
            expect(GenerateOccupationStandardExcelJob).to receive(:perform_later).once
            post path, params: params
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

          it "does not triggers pdf/excel generation" do
            expect(GenerateOccupationStandardPdfJob).to_not receive(:perform_later)
            expect(GenerateOccupationStandardExcelJob).to_not receive(:perform_later)
            post path, params: params
          end
        end
      end
    end
  end
end
