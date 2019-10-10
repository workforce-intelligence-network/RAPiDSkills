require 'rails_helper'

RSpec.describe "Admin::DataImports", type: :request do
  describe "POST #create" do
    let(:path) { admin_data_imports_path }
    let(:admin) { create(:admin) }
    let(:user) { create(:user) }

    before { sign_in admin }

    context "occupation_standards upload" do
      let!(:occupation) { create(:occupation, rapids_code: "1039HY", title: "Dog Training") }
      let!(:organization) { create(:organization, title: "Acme Dog Waling") }
      let(:params) {
        {
          data_import: {
            file: fixture_file_upload("files/dog_walking.csv", "text/csv"),
            user_id: user.id,
            kind: "occupation_standards",
            description: "this is a description",
          }
        }
      }

      context "with valid data" do
        it "saves data correctly" do
          expect{
            post path, params: params
          }.to change(DataImport, :count).by(1)
            .and change(OccupationStandard, :count).by(2)
            .and change(WorkProcess, :count).by(3)
            .and change(Skill, :count).by(5)

          di = DataImport.last
          expect(di.user).to eq user
          expect(di.description).to eq "this is a description"
          expect(di.occupation_standards?).to be true

          os1 = OccupationStandard.first
          expect(os1.title).to eq "Heeling"
          expect(os1.occupation).to eq occupation
          expect(os1.organization).to eq organization

          expect(os1.work_processes[0].title).to eq "Communicate effectively"
          expect(os1.work_processes[0].description).to eq "Communicate effectively with dog and human"
          expect(os1.work_processes[0].hours).to eq 60
          expect(os1.work_processes[1].title).to eq "Dealing with other dogs"
          expect(os1.work_processes[1].description).to eq "Handle interactions with other dogs"
          expect(os1.work_processes[1].hours).to eq 100

          expect(os1.skills[0].title).to eq "Communicate with dog"
          expect(os1.skills[1].title).to eq "Communicate with human"
          expect(os1.skills[2].title).to eq "Demonstrate ability to walk by aggressive dogs"
          expect(os1.skills[3].title).to eq "Demonstrate ability to cross intersection"

          os2 = OccupationStandard.last
          expect(os2.title).to eq "Dog Training"
          expect(os2.occupation).to eq occupation
          expect(os2.organization).to eq organization

          expect(os2.work_processes[0].title).to eq "Billing"
          expect(os2.work_processes[0].description).to eq "Bill for services"
          expect(os2.work_processes[0].hours).to eq 50

          expect(os2.skills[0].title).to eq "Understand costs"
        end
      end
    end
  end
end
