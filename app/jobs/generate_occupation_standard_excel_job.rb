class GenerateOccupationStandardExcelJob < ApplicationJob
  queue_as :default

  def perform(occupation_standard_id)
    os = OccupationStandard.find(occupation_standard_id)
    if os.should_generate_excel?
      os.excel.attach(
        io: StringIO.new(os.to_csv),
        filename: "#{os.export_filename}.csv",
        content_type: "text/csv",
      )
    end
  end
end
