class DataImport < ApplicationRecord
  include Redis::Objects

  validates :file, :kind, presence: true

  belongs_to :user
  has_one_attached :file

  enum kind: [:occupation_standards]

  value :blob_key

#  before_save :run_import, if: :file_changed?
  after_save :set_blob_key

  attr_accessor :all_sections_invalid

  def run_import
    case kind
    when "occupation_standards"
      # https://github.com/rails/rails/issues/36994
      file_data = File.read(attachment_changes['file'].attachable)
      @count = 0
      rows = []
      current_title = nil
      self.all_sections_invalid = true
      CSV.parse(file_data, headers: true) do |row|
        @count += 1
        if row["occupation_standard_title"] != current_title
          current_title = row["occupation_standard_title"]
          unless rows.empty?
            service_resp = API::V1::ImportOccupationStandard.new(
              data: rows,
              user: user,
            ).call
            self.all_sections_invalid = check_service_response(service_resp)
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

  def file_changed?
    new_record? || blob_key.value != file.blob.key
  end

  def check_service_response(service_response)
    if service_response.success?
      return false
    else
      error_msg = "[Error on line #{@count}] #{service_response.error}"
      errors.add(:base, error_msg)
      all_sections_invalid
    end
  end

  def set_blob_key
    self.blob_key = file.blob.key
  end
end
