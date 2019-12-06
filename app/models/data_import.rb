class DataImport < ApplicationRecord

  validates :file, :kind, presence: true

  belongs_to :user
  has_one_attached :file

  enum kind: [:occupation_standards]

  attr_accessor :all_sections_invalid

  def run_import
    case kind
    when "occupation_standards"
      # https://github.com/rails/rails/issues/36994
      file_data = File.read(attachment_changes['file'].attachable)
      @count = 2 # Account for header row
      rows = []
      current_title = nil
      self.all_sections_invalid = true
      CSV.parse(file_data, headers: true) do |row|
        if row["occupation_standard_title"] != current_title
          current_title = row["occupation_standard_title"]
          unless rows.empty?
            service_resp = API::V1::ImportOccupationStandard.new(
              data: rows,
              user: user,
            ).call
            self.all_sections_invalid = check_service_response(service_resp)
            @count += rows.count
          end
          rows = [row]
        else
          rows << row
        end
        service_resp = API::V1::ImportOccupationStandard.new(
          data: rows,
          user: user,
        ).call
        self.all_sections_invalid = check_service_response(service_resp)
      end
    end
  end

  private

  def check_service_response(service_response)
    if service_response.success?
      return false
    else
      error_msg = "[Error on line #{@count}] #{service_response.error}"
      errors.add(:base, error_msg)
      all_sections_invalid
    end
  end
end
