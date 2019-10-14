require 'rails_helper'

RSpec.describe OccupationStandard, type: :model do
  it "has a valid occupation standard" do
    os = build(:occupation_standard)
    expect(os.valid?).to be true
  end

  describe "#unregistered_clone" do
    let!(:occupation_standard) { create(:occupation_standard, title: "OS Title", completed_at: Time.current, published_at: Time.current) }
    let!(:oswp) { create_list(:occupation_standard_work_process, 2, occupation_standard: occupation_standard) }
    let!(:oss) { create_list(:occupation_standard_skill, 2, occupation_standard: occupation_standard) }
    let(:user) { create(:user) }
    let(:organization) { create(:organization) }

    it "creates UnregisteredStandard" do
      os = occupation_standard.unregistered_clone(creator_id: user.id, organization_id: organization.id)
      expect(os).to be_a(UnregisteredStandard)
      expect(os.skills).to match_array occupation_standard.skills
      expect(os.work_processes).to match_array occupation_standard.work_processes
      expect(os.title).to eq "OS Title"
      expect(os.occupation).to eq os.occupation
      expect(os.parent_occupation_standard).to eq occupation_standard
      expect(os.creator).to eq user
      expect(os.organization).to eq organization
      expect(os.completed_at).to be nil
      expect(os.published_at).to be nil
    end
  end
end
