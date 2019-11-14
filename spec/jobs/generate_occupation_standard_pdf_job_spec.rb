require 'rails_helper'

RSpec.describe GenerateOccupationStandardPdfJob, type: :job do
  describe "#perform" do
    shared_examples "generates pdf" do
      it "calls pdf writer and attaches file" do
        expect(OccupationStandardPdf).to receive(:new).and_call_original
        described_class.new.perform(os.id)
        os.reload
        expect(os.pdf.attached?).to be true
      end
    end

    context "when os does not have pdf attached" do
      it_behaves_like "generates pdf" do
        let(:os) { create(:occupation_standard) }
      end
    end

    context "when os has pdf attached but it is out of date" do
      it_behaves_like "generates pdf" do
        let(:os) { create(:occupation_standard, :with_pdf) }
        before { os.update!(title: "new title") }
      end
    end

    context "when os has pdf attached but it is up-to-date" do
      before { Timecop.freeze(time) }
      after { Timecop.return }
      let(:time) { Time.new(2019,11,13) }
      let!(:os) { create(:occupation_standard) }

      it "does not call pdf writer and does not attach new file" do
        os.pdf.attach(io: fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'pixel1x1.pdf'), 'application/pdf'), filename: 'file.pdf', content_type: 'application/pdf')
        os.update_columns(updated_at: time - 1.hour)
        pdf = os.pdf
        expect(OccupationStandardPdf).to_not receive(:new)
        described_class.new.perform(os.id)
        os.reload
        expect(os.pdf.attached?).to be true
        expect(os.pdf).to eq pdf
      end
    end
  end
end
