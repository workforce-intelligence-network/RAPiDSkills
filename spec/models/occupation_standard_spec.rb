require 'rails_helper'

RSpec.describe OccupationStandard, type: :model do
  it "has a valid occupation standard" do
    os = build(:occupation_standard)
    expect(os.valid?).to be true
  end

  describe ".search" do
    let(:occupation) { create(:occupation) }
    let!(:os1) { create(:occupation_standard, occupation: occupation) }
    let!(:os2) { create(:occupation_standard, occupation: occupation) }
    let!(:os3) { create(:occupation_standard) }

    it "returns all objects if options are empty" do
      expect(OccupationStandard.search).to contain_exactly os1, os2, os3
    end

    it "returns all objects if occupation_id is blank" do
      expect(OccupationStandard.search(occupation_id: nil)).to contain_exactly os1, os2, os3
    end

    it "returns filtered objects for valid occupation_id" do
      expect(OccupationStandard.search(occupation_id: occupation.id)).to contain_exactly os1, os2
    end

    it "returns no objects for invalid occupation_id" do
      expect(OccupationStandard.search(occupation_id: 9999)).to be_empty
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
    let!(:oswp) { create_list(:occupation_standard_work_process, 2, occupation_standard: occupation_standard) }
    let!(:oss) { create_list(:occupation_standard_skill, 2, occupation_standard: occupation_standard) }
    let(:user) { create(:user) }
    let(:organization) { create(:organization) }

    context "when successful" do
      it "creates UnregisteredStandard" do
        os = occupation_standard.clone_as_unregistered!(creator_id: user.id, organization_id: organization.id)
        expect(os).to be_a(UnregisteredStandard)
        expect(os.skills).to match_array occupation_standard.skills
        expect(os.work_processes).to match_array occupation_standard.work_processes
        expect(os.title).to eq "OS Title COPY"
        expect(os.occupation).to eq os.occupation
        expect(os.parent_occupation_standard).to eq occupation_standard
        expect(os.creator).to eq user
        expect(os.organization).to eq organization
        expect(os.completed_at).to be nil
        expect(os.published_at).to be nil
      end
    end

    context "when unsuccessful" do
      let(:error) { StandardError.new("error msg") }

      it "does not create new standard" do
        allow(UnregisteredStandard).to receive(:create!).and_raise(error)
        os = occupation_standard.clone_as_unregistered!(creator_id: user.id, organization_id: organization.id)
        expect(os).to be_new_record
        expect(occupation_standard.errors.full_messages.to_sentence).to eq "error msg"
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
    let(:os) { build_stubbed(:occupation_standard) }

    it "returns a string" do
      expect(os.to_csv).to be_a(String)
    end
  end
end
