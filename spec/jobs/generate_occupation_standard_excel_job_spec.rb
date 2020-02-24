require 'rails_helper'

RSpec.describe GenerateOccupationStandardExcelJob, type: :job do
  let(:os) { create(:occupation_standard) }
  let!(:oswp) { create(:occupation_standard_work_process, occupation_standard: os) }

  describe "#perform" do
    before do
      allow(OccupationStandard).to receive(:find).with(os.id).and_return(os)
    end

    context "when os should generate excel" do
      let(:os) { create(:occupation_standard) }

      before do
        allow(os).to receive(:should_generate_attachment?).with('excel').and_return(true)
      end

      it "attaches file" do
        described_class.new.perform(os.id)
        os.reload
        expect(os.excel.attached?).to be true
      end
    end

    context "when os should not generate excel" do
      let(:os) { create(:occupation_standard) }

      before do
        allow(os).to receive(:should_generate_attachment?).with('excel').and_return(false)
      end

      context "without force flag" do
        it "does not attach file" do
          described_class.new.perform(os.id)
          os.reload
          expect(os.excel.attached?).to be false
        end
      end

      context "with force flag" do
        it "attaches file" do
          described_class.new.perform(os.id, force: true)
          os.reload
          expect(os.excel.attached?).to be true
        end
      end
    end
  end
end
