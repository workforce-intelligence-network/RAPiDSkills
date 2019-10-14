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
      begin
        transaction do
          # https://github.com/rails/rails/issues/36994
          file_data = File.read(attachment_changes['file'].attachable)
          @count = 0
          CSV.parse(file_data, headers: true) do |row|
            @count += 1
            occupation = Occupation.find_by(rapids_code: row["rapids_code"])
            organization = Organization.find_by(title: row["organization_title"])
            occupation_standard = OccupationStandard.where(
              type: "#{row["type"]}Standard",
              organization: organization,
              occupation: occupation,
              title: row["occupation_standard_title"].presence || occupation.try(:title),
            ).first_or_create!(creator: user)
            work_process = WorkProcess.where(
              title: row["work_process_title"],
              description: row["work_process_description"],
            ).first_or_create!
            OccupationStandardWorkProcess.where(
              occupation_standard: occupation_standard,
              work_process: work_process,
              hours: row["work_process_hours"],
            ).first_or_create!(sort_order: row["work_process_sort"])
            skill = Skill.where(
              description: row["skill"],
              work_process: work_process,
            ).first_or_create!
            OccupationStandardSkill.where(
              occupation_standard: occupation_standard,
              skill: skill,
            ).first_or_create!(sort_order: row["skill_sort"])
          end
        end
      rescue Exception => e
        error_msg = "[Error on line #{@count}] #{e.message}"
        errors.add(:base, error_msg)
        throw(:abort)
      end
    end
  end

  def set_blob_key
    self.blob_key = file.blob.key
  end
end
