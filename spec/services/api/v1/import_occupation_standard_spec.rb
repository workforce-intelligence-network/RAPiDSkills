require 'rails_helper'

RSpec.describe API::V1::ImportOccupationStandard do
  let(:user) { create(:user) }
  subject { described_class.new(data: rows, user: user) }

  context "with valid data" do
    context "with rapids_code" do
      let!(:state) { create(:state, short_name: "CA") }
      let(:rows) { CSV.parse(File.read(fixture_file_upload("files/dog_walking_time_occupation.csv", "text/csv")), headers: true) }

      context "when occupation exists" do
        let!(:occupation) { create(:occupation, rapids_code: "1039HY", title: "Dog Training") }

        it "returns service object with success true" do
          sr = subject.call
          expect(sr).to be_a(ServiceResponse)
          expect(sr.success?).to be true
        end

        it "saves data correctly" do
          expect{
            subject.call
          }.to change(OccupationStandard, :count).by(1)
            .and change(WorkProcess, :count).by(2)
            .and change(Skill, :count).by(0)
            .and change(OccupationStandardWorkProcess, :count).by(2)
            .and change(OccupationStandardSkill, :count).by(0)
            .and change(Organization, :count).by(1)

          organization = Organization.last
          expect(organization.title).to eq "Acme Dog Walking"

          os = OccupationStandard.last
          expect(os.title).to eq "Heeling"
          expect(os.occupation).to eq occupation
          expect(os.organization).to eq organization
          expect(os.creator).to eq user
          expect(os.type).to eq "FrameworkStandard"
          expect(os.registration_organization_name).to eq "CA Dept of Labor"
          expect(os.registration_state).to eq state

          expect(os.work_processes[0].title).to eq "Communicate effectively"
          expect(os.work_processes[0].description).to eq "Communicate effectively with dog and human"
          expect(os.occupation_standard_work_processes[0].hours).to eq 60
          expect(os.work_processes[1].title).to eq "Dealing with other dogs"
          expect(os.work_processes[1].description).to eq "Handle interactions with other dogs"
          expect(os.occupation_standard_work_processes[1].hours).to eq 100
        end
      end

      context "when occupation does not exist" do
        it "returns service object with success true" do
          sr = subject.call
          expect(sr).to be_a(ServiceResponse)
          expect(sr.success?).to be true
        end

        it "saves data correctly" do
          expect{
            subject.call
          }.to change(OccupationStandard, :count).by(1)
            .and change(WorkProcess, :count).by(2)
            .and change(Skill, :count).by(0)
            .and change(OccupationStandardWorkProcess, :count).by(2)
            .and change(OccupationStandardSkill, :count).by(0)
            .and change(Organization, :count).by(1)

          organization = Organization.last
          expect(organization.title).to eq "Acme Dog Walking"

          occupation = Occupation.last
          expect(occupation.rapids_code).to eq "1039HY"
          expect(occupation.title).to eq "Heeling"
          expect(occupation.onet_code).to be nil

          os = OccupationStandard.last
          expect(os.title).to eq "Heeling"
          expect(os.occupation).to eq occupation
          expect(os.organization).to eq organization
          expect(os.creator).to eq user
          expect(os.type).to eq "FrameworkStandard"
          expect(os.registration_organization_name).to eq "CA Dept of Labor"
          expect(os.registration_state).to eq state

          expect(os.work_processes[0].title).to eq "Communicate effectively"
          expect(os.work_processes[0].description).to eq "Communicate effectively with dog and human"
          expect(os.occupation_standard_work_processes[0].hours).to eq 60
          expect(os.work_processes[1].title).to eq "Dealing with other dogs"
          expect(os.work_processes[1].description).to eq "Handle interactions with other dogs"
          expect(os.occupation_standard_work_processes[1].hours).to eq 100
        end
      end
    end

    context "with onet_code" do
      let!(:state) { create(:state, short_name: "CA") }
      let(:rows) { CSV.parse(File.read(fixture_file_upload("files/dog_walking_hybrid_occupation.csv", "text/csv")), headers: true) }

      context "when occupation exists" do
        let!(:occupation) { create(:occupation, onet_code: "1039HY", title: "Dog Training") }

        it "returns service object with success true" do
          sr = subject.call
          expect(sr).to be_a(ServiceResponse)
          expect(sr.success?).to be true
        end

        it "saves data correctly" do
          expect{
            subject.call
          }.to change(OccupationStandard, :count).by(1)
            .and change(WorkProcess, :count).by(2)
            .and change(Skill, :count).by(4)
            .and change(OccupationStandardWorkProcess, :count).by(2)
            .and change(OccupationStandardSkill, :count).by(4)
            .and change(Organization, :count).by(1)

          organization = Organization.last
          expect(organization.title).to eq "Acme Dog Walking"

          os = OccupationStandard.last
          expect(os.title).to eq "Heeling"
          expect(os.occupation).to eq occupation
          expect(os.organization).to eq organization
          expect(os.creator).to eq user
          expect(os.type).to eq "FrameworkStandard"
          expect(os.registration_organization_name).to eq "CA Dept of Labor"
          expect(os.registration_state).to eq state

          expect(os.work_processes[0].title).to eq "Communicate effectively"
          expect(os.work_processes[0].description).to eq "Communicate effectively with dog and human"
          expect(os.occupation_standard_work_processes[0].hours).to eq 60
          expect(os.work_processes[1].title).to eq "Dealing with other dogs"
          expect(os.work_processes[1].description).to eq "Handle interactions with other dogs"
          expect(os.occupation_standard_work_processes[1].hours).to eq 100

          expect(os.flattened_skills[0].description).to eq "Communicate with dog"
          expect(os.flattened_skills[1].description).to eq "Communicate with human"
          expect(os.flattened_skills[2].description).to eq "Demonstrate ability to walk by aggressive dogs"
          expect(os.flattened_skills[3].description).to eq "Demonstrate ability to cross intersection"
          expect(os.occupation_standard_skills[0].occupation_standard_work_process).to eq os.occupation_standard_work_processes[0]
          expect(os.occupation_standard_skills[1].occupation_standard_work_process).to eq os.occupation_standard_work_processes[0]
          expect(os.occupation_standard_skills[2].occupation_standard_work_process).to eq os.occupation_standard_work_processes[1]
          expect(os.occupation_standard_skills[3].occupation_standard_work_process).to eq os.occupation_standard_work_processes[1]
        end
      end

      context "when occupation does not exists" do
        it "returns service object with success true" do
          sr = subject.call
          expect(sr).to be_a(ServiceResponse)
          expect(sr.success?).to be true
        end

        it "saves data correctly" do
          expect{
            subject.call
          }.to change(OccupationStandard, :count).by(1)
            .and change(WorkProcess, :count).by(2)
            .and change(Skill, :count).by(4)
            .and change(OccupationStandardWorkProcess, :count).by(2)
            .and change(OccupationStandardSkill, :count).by(4)
            .and change(Organization, :count).by(1)

          organization = Organization.last
          expect(organization.title).to eq "Acme Dog Walking"

          occupation = Occupation.last
          expect(occupation.onet_code).to eq "1039HY"
          expect(occupation.title).to eq "Heeling"
          expect(occupation.rapids_code).to be nil

          os = OccupationStandard.last
          expect(os.title).to eq "Heeling"
          expect(os.occupation).to eq occupation
          expect(os.organization).to eq organization
          expect(os.creator).to eq user
          expect(os.type).to eq "FrameworkStandard"
          expect(os.registration_organization_name).to eq "CA Dept of Labor"
          expect(os.registration_state).to eq state

          expect(os.work_processes[0].title).to eq "Communicate effectively"
          expect(os.work_processes[0].description).to eq "Communicate effectively with dog and human"
          expect(os.occupation_standard_work_processes[0].hours).to eq 60
          expect(os.work_processes[1].title).to eq "Dealing with other dogs"
          expect(os.work_processes[1].description).to eq "Handle interactions with other dogs"
          expect(os.occupation_standard_work_processes[1].hours).to eq 100

          expect(os.flattened_skills[0].description).to eq "Communicate with dog"
          expect(os.flattened_skills[1].description).to eq "Communicate with human"
          expect(os.flattened_skills[2].description).to eq "Demonstrate ability to walk by aggressive dogs"
          expect(os.flattened_skills[3].description).to eq "Demonstrate ability to cross intersection"
          expect(os.occupation_standard_skills[0].occupation_standard_work_process).to eq os.occupation_standard_work_processes[0]
          expect(os.occupation_standard_skills[1].occupation_standard_work_process).to eq os.occupation_standard_work_processes[0]
          expect(os.occupation_standard_skills[2].occupation_standard_work_process).to eq os.occupation_standard_work_processes[1]
          expect(os.occupation_standard_skills[3].occupation_standard_work_process).to eq os.occupation_standard_work_processes[1]
        end
      end
    end

    context "with neither rapids_code nor onet_code" do
      let!(:state) { create(:state, short_name: "CA") }
      let(:rows) { CSV.parse(File.read(fixture_file_upload("files/dog_walking_competency_occupation.csv", "text/csv")), headers: true) }

      it "returns service object with success true" do
        sr = subject.call
        expect(sr).to be_a(ServiceResponse)
        expect(sr.success?).to be true
      end

      it "saves data correctly" do
        expect{
          subject.call
        }.to change(Occupation, :count).by(1)
          .and change(OccupationStandard, :count).by(1)
          .and change(WorkProcess, :count).by(0)
          .and change(Skill, :count).by(2)
          .and change(OccupationStandardWorkProcess, :count).by(0)
          .and change(OccupationStandardSkill, :count).by(2)
          .and change(Organization, :count).by(1)

        occupation = Occupation.last
        expect(occupation.title).to eq "Heeling"
        expect(occupation.rapids_code).to be_blank
        expect(occupation.onet_code).to be_blank
        expect(occupation).to be_a(CompetencyOccupation)

        organization = Organization.last
        expect(organization.title).to eq "Acme Dog Walking"

        os = OccupationStandard.last
        expect(os.title).to eq "Heeling"
        expect(os.occupation).to eq occupation
        expect(os.organization).to eq organization
        expect(os.creator).to eq user
        expect(os.type).to eq "FrameworkStandard"
        expect(os.registration_organization_name).to eq "CA Dept of Labor"
        expect(os.registration_state).to eq state

        expect(os.occupation_standard_skills[0].skill.description).to eq "Communicate with dog"
        expect(os.occupation_standard_skills[1].skill.description).to eq "Communicate with human"
      end
    end

    context "with categories" do
      let!(:occupation) { create(:occupation, onet_code: "1039HY", title: "Dog Training") }
      let!(:state) { create(:state, short_name: "CA") }
      let(:rows) { CSV.parse(File.read(fixture_file_upload("files/dog_walking_hybrid_with_categories.csv", "text/csv")), headers: true) }

      it "returns service object with success true" do
        sr = subject.call
        expect(sr).to be_a(ServiceResponse)
        expect(sr.success?).to be true
      end

      it "saves data correctly" do
        expect{
          subject.call
        }.to change(Occupation, :count).by(0)
          .and change(OccupationStandard, :count).by(1)
          .and change(WorkProcess, :count).by(2)
          .and change(Skill, :count).by(6)
          .and change(OccupationStandardWorkProcess, :count).by(2)
          .and change(OccupationStandardSkill, :count).by(6)
          .and change(Category, :count).by(3)
          .and change(Organization, :count).by(1)

        organization = Organization.last
        expect(organization.title).to eq "Acme Dog Walking"

        os = OccupationStandard.last
        expect(os.title).to eq "Heeling"
        expect(os.occupation).to eq occupation
        expect(os.organization).to eq organization
        expect(os.creator).to eq user
        expect(os.type).to eq "FrameworkStandard"
        expect(os.registration_organization_name).to eq "CA Dept of Labor"
        expect(os.registration_state).to eq state

        oswp1 = os.occupation_standard_work_processes[0]
        oswp2 = os.occupation_standard_work_processes[1]
        expect(oswp1.work_process.title).to eq "Communicate effectively"
        expect(oswp1.work_process.description).to eq "Communicate effectively with dog and human"
        expect(oswp1.hours).to eq 60
        expect(oswp1.sort_order).to eq 1

        expect(oswp2.work_process.title).to eq "Dealing with other dogs"
        expect(oswp2.work_process.description).to eq "Handle interactions with other dogs"
        expect(oswp2.hours).to eq 100
        expect(oswp2.sort_order).to eq 2

        category1 = Category.first
        expect(category1.occupation_standard_work_process).to eq oswp1
        expect(category1.name).to eq "Safety Procedures"
        expect(category1.sort_order).to eq 1

        category2 = Category.all[1]
        expect(category2.occupation_standard_work_process).to eq oswp1
        expect(category2.name).to eq "Safety Features"
        expect(category2.sort_order).to eq 2

        category3 = Category.last
        expect(category3.occupation_standard_work_process).to eq oswp2
        expect(category3.name).to eq "Handling Procedures"
        expect(category3.sort_order).to eq 1

        expect(os.occupation_standard_skills[0].skill.description).to eq "Communicate with dog"
        expect(os.occupation_standard_skills[0].occupation_standard_work_process).to eq oswp1
        expect(os.occupation_standard_skills[0].category).to eq category1

        expect(os.occupation_standard_skills[1].skill.description).to eq "Communicate with human"
        expect(os.occupation_standard_skills[1].occupation_standard_work_process).to eq oswp1
        expect(os.occupation_standard_skills[1].category).to eq category1

        expect(os.occupation_standard_skills[2].skill.description).to eq "Muzzle dog"
        expect(os.occupation_standard_skills[2].occupation_standard_work_process).to eq oswp1
        expect(os.occupation_standard_skills[2].category).to eq category2

        expect(os.occupation_standard_skills[3].skill.description).to eq "Muzzle cat"
        expect(os.occupation_standard_skills[3].occupation_standard_work_process).to eq oswp1
        expect(os.occupation_standard_skills[3].category).to eq category2

        expect(os.occupation_standard_skills[4].skill.description).to eq "Demonstrate ability to walk by aggressive dogs"
        expect(os.occupation_standard_skills[4].occupation_standard_work_process).to eq oswp2
        expect(os.occupation_standard_skills[4].category).to eq category3

        expect(os.occupation_standard_skills[5].skill.description).to eq "Demonstrate ability to cross intersection"
        expect(os.occupation_standard_skills[5].occupation_standard_work_process).to eq oswp2
        expect(os.occupation_standard_skills[5].category).to eq category3
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
        expect(sr.error).to eq "Either work process or skill is required"
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
