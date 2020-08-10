class GenerateOccupationStandardPdfJob < ApplicationJob
  queue_as :default

  def perform(occupation_standard_id, force: false)
    os = OccupationStandard.find(occupation_standard_id)
    if force || os.should_generate_attachment?('pdf')
      os.generate_pdf!
    end
  end
end
