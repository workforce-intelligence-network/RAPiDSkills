require 'rails_helper'

RSpec.describe OccupationStandardSkillPolicy, type: :policy do
  let(:os) { create(:occupation_standard) }
  let(:oss) { create(:occupation_standard_skill, occupation_standard: os) }

  subject { described_class }

  permissions :update? do
    it "denies access if occupation_standard creator is not current user" do
      expect(subject).to_not permit(create(:user), oss)
    end

    it "grants access if occupation_standard creator is current user" do
      expect(subject).to permit(os.creator, oss)
    end
  end
end
