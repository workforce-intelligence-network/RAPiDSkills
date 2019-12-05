class DataImport < ApplicationRecord
  include Redis::Objects

  validates :file, :kind, presence: true

  belongs_to :user
  has_one_attached :file

  enum kind: [:occupation_standards]

  value :blob_key

  before_save :run_import, if: :file_changed?
  after_save :set_blob_key

  private

  def file_changed?
    new_record? || blob_key.value != file.blob.key
  end

  def run_import
    case kind
    when "occupation_standards"
      # https://github.com/rails/rails/issues/36994
      file_data = File.read(attachment_changes['file'].attachable)
      @count = 0
      rows = []
      current_occupation_standard_title = nil
      all_sections_invalid = true
      CSV.parse(file_data, headers: true) do |row|
        @count += 1
        if row["occupation_standard_title"] != current_occupation_standard_title
          current_occupation_standard_title = row["occupation_standard_title"]
          unless rows.empty?
            service_resp = API::V1::ImportOccupationStandard.new(data: rows, user: user).call
            if service_resp.success?
              all_sections_invalid = false
            else
              error_msg = "[Error on line #{@count}] #{service_resp.error}"
              errors.add(:base, error_msg)
            end
          end
          rows = [row]
        else
          rows << row
        end
        service_resp = API::V1::ImportOccupationStandard.new(data: rows, user: user).call
        if service_resp.success?
          all_sections_invalid = false
        else
          error_msg = "[Error on line #{@count}] #{service_resp.error}"
          errors.add(:base, error_msg)
        end
      end
      throw(:abort) if all_sections_invalid && @count > 0
    end
  end

  def set_blob_key
    self.blob_key = file.blob.key
  end
end
