require 'rails_helper'

RSpec.describe OccupationStandard, type: :model do
  it "has a valid occupation standard" do
    os = build(:occupation_standard)
    expect(os.valid?).to be true
  end

  describe ".search_records" do
    before { OccupationStandard.reindex }
    
    context "by occupation" do
      let(:occupation) { create(:occupation) }
      let!(:os1) { create(:occupation_standard, occupation: occupation) }
      let!(:os2) { create(:occupation_standard, occupation: occupation) }
      let!(:os3) { create(:occupation_standard) }

      it "returns all objects if options are empty" do
        expect(OccupationStandard.search_records).to contain_exactly os1, os2, os3
      end

      it "returns all objects if occupation_id is blank" do
        expect(OccupationStandard.search_records(occupation_id: nil)).to contain_exactly os1, os2, os3
      end

      it "returns filtered objects for valid occupation_id" do
        expect(OccupationStandard.search_records(occupation_id: occupation.id)).to contain_exactly os1, os2
      end

      it "returns no objects for invalid occupation_id" do
        expect(OccupationStandard.search_records(occupation_id: 9999)).to be_empty
      end
    end

    context "by creator" do
      let(:user) { create(:user) }
      let!(:os1) { create(:occupation_standard, creator: user) }
      let!(:os2) { create(:occupation_standard, creator: user) }
      let!(:os3) { create(:occupation_standard) }

      it "returns all objects if options are empty" do
        expect(OccupationStandard.search_records).to contain_exactly os1, os2, os3
      end

      it "returns all objects if creator_id is blank" do
        expect(OccupationStandard.search_records(creator: nil)).to contain_exactly os1, os2, os3
      end

      it "returns filtered objects for valid creator_id" do
        expect(OccupationStandard.search_records(creator: user.id)).to contain_exactly os1, os2
      end

      it "returns no objects for invalid creator_id" do
        expect(OccupationStandard.search_records(creator: 9999)).to be_empty
      end
    end

    context "by multiple fields" do
      let(:occupation) { create(:occupation) }
      let(:user) { create(:user) }
      let!(:os1) { create(:occupation_standard, creator: user, occupation: occupation) }
      let!(:os2) { create(:occupation_standard, creator: user) }
      let!(:os3) { create(:occupation_standard, occupation: occupation) }

      it "returns all objects if options are empty" do
        expect(OccupationStandard.search_records).to contain_exactly os1, os2, os3
      end

      it "returns occupation objects if creator_id is blank" do
        expect(OccupationStandard.search_records(occupation_id: occupation.id, creator: nil)).to contain_exactly os1, os3
      end

      it "returns filtered objects for valid creator_id, occupation_id" do
        expect(OccupationStandard.search_records(occupation_id: occupation.id, creator: user.id)).to eq [os1]
      end

      it "returns no objects for invalid creator_id, valid  occupation" do
        expect(OccupationStandard.search_records(occupation_id: occupation.id, creator: 9999)).to be_empty
      end
    end
  end

  describe "#skills" do
    let(:os) { create(:occupation_standard) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: nil) }

    it "returns skills with no work process" do
      expect(os.skills).to eq [oss2.skill]
    end
  end

  describe "#flattened_skills" do
    let(:os) { create(:occupation_standard) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: nil) }

    it "returns all skills" do
      expect(os.flattened_skills).to match_array [oss1.skill, oss2.skill]
    end
  end

  describe "#occupation_standard_skills_with_no_work_process" do
    let(:os) { create(:occupation_standard) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: nil) }

    it "returns occupation_standard skills with no work process" do
      expect(os.occupation_standard_skills_with_no_work_process).to eq [oss2]
    end
  end

  describe "#clone_as_unregistered!" do
    let!(:occupation_standard) { create(:occupation_standard, title: "OS Title", completed_at: Time.current, published_at: Time.current) }
    let!(:oswp1) { create(:occupation_standard_work_process, occupation_standard: occupation_standard) }
    let!(:oswp2) { create(:occupation_standard_work_process, occupation_standard: occupation_standard) }
    let!(:oss1a) { create(:occupation_standard_skill, occupation_standard: occupation_standard, occupation_standard_work_process: oswp1) }
    let!(:oss1b) { create(:occupation_standard_skill, occupation_standard: occupation_standard, occupation_standard_work_process: oswp1) }
    let!(:oss) { create(:occupation_standard_skill, occupation_standard: occupation_standard, occupation_standard_work_process: nil) }
    let(:user) { create(:user) }
    let(:organization) { create(:organization) }

    context "when successful" do
      context "when no title is passed" do
        it "creates UnregisteredStandard" do
          os = occupation_standard.clone_as_unregistered!(creator_id: user.id, organization_id: organization.id)
          expect(os).to be_a(UnregisteredStandard)
          expect(os.work_processes).to match_array [oswp1.work_process, oswp2.work_process]
          expect(os.occupation_standard_work_processes.flat_map(&:skills)).to match_array [oss1a.skill, oss1b.skill]
          expect(os.skills).to match_array [oss.skill]
          expect(os.title).to eq "OS Title COPY"
          expect(os.occupation).to eq os.occupation
          expect(os.parent_occupation_standard).to eq occupation_standard
          expect(os.creator).to eq user
          expect(os.organization).to eq organization
          expect(os.completed_at).to be nil
          expect(os.published_at).to be nil
        end
      end

      context "when title is passed" do
        it "sets title" do
          os = occupation_standard.clone_as_unregistered!(creator_id: user.id, organization_id: organization.id, new_title: "New Title")
          expect(os.title).to eq "New Title"
        end
      end
    end

    context "when unsuccessful" do
      let(:error) { StandardError.new("error msg") }

      it "does not create new standard" do
        allow(UnregisteredStandard).to receive(:create!).and_raise(error)
        os = occupation_standard.clone_as_unregistered!(creator_id: user.id, organization_id: organization.id)
        expect(os).to be_new_record
        expect(os.errors.full_messages.to_sentence).to eq "error msg"
      end
    end
  end

  describe "#should_generate_attachment?" do
    context "when no pdf attached" do
      let(:os) { create(:occupation_standard) }

      it "returns true" do
        expect(os.should_generate_attachment?('pdf')).to be true
      end
    end

    context "when pdf attached" do
      let(:os) { create(:occupation_standard, :with_pdf) }

      context "when pdf is out of date" do
        before { os.update_columns(updated_at: Time.current + 1.minute) }

        it "returns true" do
          os.reload
          expect(os.should_generate_attachment?('pdf')).to be true
        end
      end

      context "when pdf is up-to-date" do
        context "when actual time difference" do
          before { os.update_columns(updated_at: Time.current - 1.hour) }

          it "returns false" do
            os.reload
            expect(os.should_generate_attachment?('pdf')).to be false
          end
        end

        context "when times match up within a second" do
          before { os.update_columns(updated_at: Time.current + 5/1000) }

          it "returns false" do
            os.reload
            expect(os.should_generate_attachment?('pdf')).to be false
          end
        end
      end
    end
  end

  describe "#to_csv" do
    let(:os) { create(:occupation_standard) }
    let!(:oswp1) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:oswp2) { create(:occupation_standard_work_process, occupation_standard: os) }
    let!(:category) { create(:category, occupation_standard_work_process: oswp1) }
    let!(:oss1) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp1) }
    let!(:oss2) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: nil) }
    let!(:oss3) { create(:occupation_standard_skill, occupation_standard: os, occupation_standard_work_process: oswp1, category: category) }

    it "returns a string" do
      expect(os.to_csv).to be_a(String)
    end
  end

  describe "#registration_state_name" do
    context "when registration state exists" do
      let(:rs) { build_stubbed(:state, short_name: "short") }
      let(:os) { build_stubbed(:occupation_standard, registration_state: rs) }

      it "returns short name" do
        expect(os.registration_state_name).to eq "short"
      end
    end

    context "when registration state does not exist" do
      let(:os) { build_stubbed(:occupation_standard) }

      it "returns short name" do
        expect(os.registration_state_name).to be nil
      end
    end
  end

  describe "#work_processes_count" do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:os) { build_stubbed(:occupation_standard) }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      allow(os).to receive(:work_processes).and_return(build_list(:work_process, 2))
    end

    context "when cache is not set" do
      it "returns work processes count and sets cache" do
        expect(os.work_processes_count).to eq 2
        expect(Rails.cache.read("#{os.cache_key}/work_processes_count")).to eq 2
        os2 = create(:occupation_standard)
        expect(os2.work_processes_count).to eq 0
      end
    end

    context "when cache is set" do
      it "returns cache" do
        Rails.cache.write("#{os.cache_key}/work_processes_count", 3)
        expect(os.work_processes_count).to eq 3
      end
    end
  end

  describe "#skills_count" do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:os) { build_stubbed(:occupation_standard) }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      allow(os).to receive(:flattened_skills).and_return(build_list(:skill, 2))
    end

    context "when cache is not set" do
      it "returns skills count and sets cache" do
        expect(os.skills_count).to eq 2
        expect(Rails.cache.read("#{os.cache_key}/skills_count")).to eq 2
        os2 = create(:occupation_standard)
        expect(os2.skills_count).to eq 0
      end
    end

    context "when cache is set" do
      it "returns cache" do
        Rails.cache.write("#{os.cache_key}/skills_count", 3)
        expect(os.skills_count).to eq 3
      end
    end
  end

  describe "#hours_count" do
    let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
    let(:os) { create(:occupation_standard) }
    let!(:oswp1) { create(:occupation_standard_work_process, occupation_standard: os, hours: 20) }
    let!(:oswp2) { create(:occupation_standard_work_process, occupation_standard: os, hours: 40) }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
    end

    context "when cache is not set" do
      it "returns work processes hours count and sets cache" do
        expect(os.hours_count).to eq 60
        expect(Rails.cache.read("#{os.cache_key}/hours_count")).to eq 60
        os2 = create(:occupation_standard)
        expect(os2.hours_count).to eq 0
      end
    end

    context "when cache is set" do
      it "returns cache" do
        Rails.cache.write("#{os.cache_key}/hours_count", 3)
        expect(os.hours_count).to eq 3
      end
    end
  end
end
