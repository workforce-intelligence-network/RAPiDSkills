require 'rails_helper'

RSpec.describe API::V1::ImportOccupationStandard do
  let(:user) { create(:user) }
  subject { described_class.new(data: rows, user: user) }

  context "with valid data" do
    context "with rapids_code" do
      let!(:occupation) { create(:occupation, rapids_code: "1039HY", title: "Dog Training") }
      let(:rows) { CSV.parse(File.read(fixture_file_upload("files/dog_walking.csv", "text/csv")), headers: true) }

      it "returns service object with success true" do
        sr = subject.call
        expect(sr).to be_a(ServiceResponse)
        expect(sr.success?).to be true
      end

      it "saves data correctly" do
        expect{
          subject.call
        }.to change(OccupationStandard, :count).by(2)
          .and change(WorkProcess, :count).by(3)
          .and change(Skill, :count).by(5)
          .and change(OccupationStandardWorkProcess, :count).by(3)
          .and change(OccupationStandardSkill, :count).by(5)
          .and change(Organization, :count).by(1)

        organization = Organization.last
        expect(organization.title).to eq "Acme Dog Walking"

        os1 = OccupationStandard.first
        expect(os1.title).to eq "Heeling"
        expect(os1.occupation).to eq occupation
        expect(os1.organization).to eq organization
        expect(os1.creator).to eq user
        expect(os1.type).to eq "FrameworkStandard"

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
      let!(:occupation1) { create(:occupation, title: "addictions counselor") }
      let!(:occupation2) { create(:occupation, onet_code: "0569CB") }
      let(:rows) { CSV.parse(File.read(fixture_file_upload("files/hcap.csv", "text/csv")), headers: true) }

      it "saves data correctly" do
        expect{
          subject.call
        }.to change(Occupation, :count).by(1)
          .and change(OccupationStandard, :count).by(3)
          .and change(WorkProcess, :count).by(2)
          .and change(Skill, :count).by(6)
          .and change(OccupationStandardWorkProcess, :count).by(2)
          .and change(OccupationStandardSkill, :count).by(6)
          .and change(Organization, :count).by(3)

        occupation = Occupation.last
        expect(occupation.title).to eq "Central Sterile Processing Technician"
        expect(occupation.rapids_code).to be_blank
        expect(occupation.onet_code).to be_blank
        expect(occupation).to be_a(CompetencyOccupation)
      end
    end
  end

  context "with invalid data" do
    context "with no work process nor skills" do
      let(:rows) { CSV.parse(File.read(fixture_file_upload("files/bad_occupation_type.csv", "text/csv")), headers: true) }

      it "returns service object with success false" do
        sr = subject.call
        expect(sr).to be_a(ServiceResponse)
        expect(sr.success?).to be false
        expect(sr.error).to eq "[Error on line 1] Either work process or skill is required"
      end

      it "does not save data" do
        expect{
          subject.call
        }.to change(OccupationStandard, :count).by(0)
          .and change(WorkProcess, :count).by(0)
          .and change(Skill, :count).by(0)
          .and change(OccupationStandardWorkProcess, :count).by(0)
          .and change(OccupationStandardSkill, :count).by(0)
      end
    end
  end
end
