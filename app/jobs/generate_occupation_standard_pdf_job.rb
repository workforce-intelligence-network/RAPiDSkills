class GenerateOccupationStandardPdfJob < ApplicationJob
  queue_as :default

  def perform(occupation_standard_id)
    os = OccupationStandard.find(occupation_standard_id)
    if os.should_generate_attachment?('pdf')
      pdf = ::OccupationStandardPdf.new(os)
      os.pdf.attach(io: StringIO.new(pdf.render), filename: "#{os.title.parameterize(separator: '_')}_#{I18n.l(Time.current, format: :filename)}.pdf")
    end
  end
end
