class GenerateOccupationStandardPdfJob < ApplicationJob
  queue_as :default

  def perform(occupation_standard_id, force: false)
    os = OccupationStandard.find(occupation_standard_id)
    if force || os.should_generate_attachment?('pdf')
      pdf = ::OccupationStandardPdf.new(os)
      os.pdf.attach(
        io: StringIO.new(pdf.render),
        filename: "#{os.export_filename}.pdf",
        content_type: "application/pdf",
      )
    end
  end
end
