class OccupationStandard < ApplicationRecord
  belongs_to :organization
  belongs_to :occupation
  belongs_to :industry, optional: true
  belongs_to :creator, class_name: 'User'
  belongs_to :parent_occupation_standard, class_name: 'OccupationStandard', optional: true
  has_many :occupation_standard_skills, -> { order(:sort_order) }
  has_many :skills, through: :occupation_standard_skills
  has_many :occupation_standard_work_processes, -> { order(:sort_order) }
  has_many :work_processes, through: :occupation_standard_work_processes
  has_many :standards_registrations

  has_one_attached :pdf
  has_one_attached :excel

  validates :title, presence: true

  delegate :rapids_code, to: :occupation
  delegate :title, to: :organization, prefix: true
  delegate :title, to: :occupation, prefix: true
  delegate :title, to: :industry, prefix: true, allow_nil: true
  delegate :name, to: :creator, prefix: true

  scope :occupation, ->(occupation_id) { where(occupation_id: occupation_id) if occupation_id.present? }

  class << self
    def search(args={})
      occupation(args[:occupation_id])
    end
  end

  def clone_as_unregistered!(creator_id:, organization_id:)
    begin
      OccupationStandard.transaction do
        os = UnregisteredStandard.create!(
          creator_id: creator_id,
          organization_id: organization_id,
          occupation: occupation,
          title: "#{title} COPY",
          parent_occupation_standard: self,
        )

        os.occupation_standard_work_processes = occupation_standard_work_processes.map(&:dup)
        os.occupation_standard_skills = occupation_standard_skills.map(&:dup)

        os
      end
    rescue Exception => e
      errors.add(:base, e.message)
      OccupationStandard.new
    end
  end

  def should_generate_excel?
    # Record updated_at stamp gets set milliseconds after excel created_at
    !excel.attached? || excel.created_at < updated_at - 1.second
  end

  def to_csv
    CSV.generate do |csv|
      csv << %w(rapids_code organization_title occupation_standard_title type work_process_title work_process_description work_process_hours work_process_sort skill skill_sort)
      occupation_standard_work_processes.includes(:work_process, :occupation_standard_skills, :skills).each do |oswp|
        array = [rapids_code, organization_title, title, type.gsub('Standard', ''), oswp.work_process_title, oswp.work_process_description, oswp.hours, oswp.sort_order]
        if oswp.skills.any?
          oswp.occupation_standard_skills.each do |oss|
            csv << array + [oss.skill_description, oss.sort_order]
          end
        else
          csv << array
        end
      end
    end
  end

  def to_s
    "#{title} (#{organization.title})"
  end
end
