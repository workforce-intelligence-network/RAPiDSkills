class OccupationStandard < ApplicationRecord
  belongs_to :organization
  belongs_to :occupation
  belongs_to :industry, optional: true
  belongs_to :creator, class_name: 'User'
  belongs_to :parent_occupation_standard, class_name: 'OccupationStandard', optional: true
  has_many :occupation_standard_skills, -> { includes(:skill).order(:sort_order) }
  has_many :flattened_skills, through: :occupation_standard_skills,
    class_name: 'Skill', source: :skill
  has_many :occupation_standard_work_processes, -> { includes(:work_process, :occupation_standard_skills).order(:sort_order) }
  has_many :work_processes, through: :occupation_standard_work_processes
  has_many :occupation_standard_skills_with_no_work_process, -> { where(occupation_standard_work_process: nil).order(:sort_order) }, class_name: 'OccupationStandardSkill'
  has_many :skills, through: :occupation_standard_skills_with_no_work_process
  has_many :standards_registrations

  has_one_attached :pdf
  has_one_attached :excel

  validates :title, presence: true

  delegate :rapids_code, to: :occupation
  delegate :onet_code, to: :occupation
  delegate :title, to: :organization, prefix: true
  delegate :title, to: :occupation, prefix: true
  delegate :title, to: :industry, prefix: true, allow_nil: true
  delegate :name, to: :creator, prefix: true

  scope :occupation, ->(occupation_id) { where(occupation_id: occupation_id) if occupation_id.present? }

  CSV_HEADERS = %w(rapids_code onet_code organization_title occupation_standard_title type work_process_title work_process_description work_process_hours work_process_sort skill skill_sort).freeze

  def occupation_standard_skills_with_no_work_process_ids
    occupation_standard_skills_with_no_work_process.pluck(:id)
  end

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

  def should_generate_attachment?(kind)
    # Occupation standard updated_at timestamp gets set milliseconds after
    # attachment created_at timestamp.
    !send(kind).attached? || send(kind).created_at < updated_at - 1.second
  end

  def to_csv
    CSV.generate do |csv|
      csv << CSV_HEADERS
      occupation_standard_work_processes.each do |oswp|
        if oswp.skills.any?
          oswp.occupation_standard_skills.each do |oss|
            csv << work_process_with_skill_row(oss)
          end
        else
          csv << work_process_row(oswp)
        end
      end

      occupation_standard_skills_with_no_work_process.each do |oss|
        csv << skill_row(oss)
      end
    end
  end

  def export_filename
    "#{title.parameterize(separator: '_')}_#{I18n.l(Time.current, format: :filename)}"
  end

  def work_process_with_skill_row(oss)
    work_process_row(oss.occupation_standard_work_process) + skill_fields(oss)
  end

  def work_process_row(oswp)
    common_fields + work_process_fields(oswp)
  end

  def skill_row(oss)
    common_fields + work_process_fields + skill_fields(oss)
  end

  def common_fields
    [rapids_code, onet_code, organization_title, title, type.gsub('Standard', '')]
  end

  def work_process_fields(oswp=nil)
    [oswp.try(:work_process_title), oswp.try(:work_process_description), oswp.try(:hours), oswp.try(:sort_order)]
  end

  def skill_fields(oss)
    [oss.skill_description, oss.sort_order]
  end

  def to_s
    "#{title} (#{organization.title})"
  end
end
