class GenerateOccupationStandardExcelJob < ApplicationJob
  queue_as :default

  def perform(occupation_standard_id, force: false)
    os = OccupationStandard.find(occupation_standard_id)
    if force || os.should_generate_attachment?('excel')
      os.excel.attach(
        io: StringIO.new(os.to_csv),
        filename: "#{os.export_filename}.csv",
        content_type: "text/csv",
      )
    end
  end
end
