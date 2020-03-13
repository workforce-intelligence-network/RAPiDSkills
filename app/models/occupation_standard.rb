class OccupationStandard < ApplicationRecord
  belongs_to :organization
  belongs_to :occupation
  belongs_to :industry, optional: true
  belongs_to :creator, class_name: 'User'
  belongs_to :parent_occupation_standard, class_name: 'OccupationStandard', optional: true
  belongs_to :registration_state, class_name: 'State', optional: true
  has_many :occupation_standard_skills, -> { includes(:skill).order(:sort_order) }, dependent: :destroy
  has_many :flattened_skills, through: :occupation_standard_skills,
    class_name: 'Skill', source: :skill
  has_many :occupation_standard_work_processes, -> { preload(:categories, :occupation_standard_skills, :work_process).order(:sort_order) },
    dependent: :destroy
  has_many :work_processes, through: :occupation_standard_work_processes
  has_many :occupation_standard_skills_with_no_work_process, -> { includes(:skill).where(occupation_standard_work_process: nil).order(:sort_order) }, class_name: 'OccupationStandardSkill'
  has_many :skills, through: :occupation_standard_skills_with_no_work_process
  has_many :standards_registrations, dependent: :destroy
  has_many :relationships, dependent: :destroy

  has_one_attached :pdf
  has_one_attached :excel

  validates :title, presence: true

  delegate :rapids_code, to: :occupation, prefix: true
  delegate :onet_code, to: :occupation, prefix: true
  delegate :kind, to: :occupation, prefix: true
  delegate :type, to: :occupation, prefix: true
  delegate :title, to: :organization, prefix: true
  delegate :title, to: :occupation, prefix: true
  delegate :title, to: :industry, prefix: true, allow_nil: true
  delegate :name, to: :creator, prefix: true

  scope :occupation, ->(occupation_id) { where(occupation_id: occupation_id) if occupation_id.present? }
  scope :creator, ->(creator_id) { where(creator_id: creator_id) if creator_id.present? }

  scope :with_eager_loading, -> { includes(:creator, :occupation, :industry, :parent_occupation_standard, :occupation_standard_skills_with_no_work_process, :occupation_standard_work_processes, :registration_state, pdf_attachment: :blob, excel_attachment: :blob, organization: [logo_attachment: :blob]) }

  CSV_HEADERS = %w(rapids_code onet_code organization_title registration_organization_name registration_state occupation_standard_title type work_process_title work_process_description work_process_hours work_process_sort category category_sort skill skill_sort).freeze

  def occupation_standard_skills_with_no_work_process_ids
    occupation_standard_skills_with_no_work_process.pluck(:id)
  end

  class << self
    def search(args={})
      occupation(args[:occupation_id])
        .creator(args[:creator])
    end
  end

  def clone_as_unregistered!(creator_id:, organization_id:, new_title: nil)
    begin
      new_title ||= "#{title} COPY"
      OccupationStandard.transaction do
        os = UnregisteredStandard.create!(
          creator_id: creator_id,
          organization_id: organization_id,
          occupation: occupation,
          title: new_title,
          parent_occupation_standard: self,
        )

        occupation_standard_work_processes.each do |oswp|
          new_oswp = oswp.dup
          new_oswp.update!(occupation_standard: os)

          oswp.occupation_standard_skills.each do |oss|
            new_oss = oss.dup
            new_oss.update!(
              occupation_standard: os,
              occupation_standard_work_process: new_oswp,
            )
          end
        end

        # Catch any skills that are not linked to work processes
        skills.each do |skill|
          # Fail silently if occupation_standard_skill already exists
          os.occupation_standard_skills.create(skill: skill)
        end

        os
      end
    rescue Exception => e
      os = OccupationStandard.new
      os.errors.add(:base, e.message)
      os
    end
  end

  def registration_state_name
    registration_state&.short_name
  end

  def work_processes_count
    Rails.cache.fetch(method_cache_key(__method__)) { work_processes.count }
  end

  def skills_count
    Rails.cache.fetch(method_cache_key(__method__)) { flattened_skills.count }
  end

  def hours_count
    Rails.cache.fetch(method_cache_key(__method__)) { occupation_standard_work_processes.sum(:hours) }
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
        if oswp.categories.any?
          oswp.categories.each do |category|
            category.occupation_standard_skills.each do |oss|
              csv << work_process_with_category_row(oss)
            end
          end
        elsif oswp.skills.any?
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

  def work_process_with_category_row(oss)
    work_process_row(oss.occupation_standard_work_process) + category_fields(oss.category) + skill_fields(oss)
  end

  def work_process_with_skill_row(oss)
    work_process_row(oss.occupation_standard_work_process) + category_fields + skill_fields(oss)
  end

  def work_process_row(oswp)
    common_fields + work_process_fields(oswp)
  end

  def skill_row(oss)
    common_fields + work_process_fields + category_fields + skill_fields(oss)
  end

  def common_fields
    [occupation_rapids_code, occupation_onet_code, organization_title, registration_organization_name, registration_state_name, title, type.gsub('Standard', '')]
  end

  def work_process_fields(oswp=nil)
    [oswp.try(:work_process_title), oswp.try(:work_process_description), oswp.try(:hours), oswp.try(:sort_order)]
  end

  def category_fields(category=nil)
    [category.try(:name), category.try(:sort_order)]
  end

  def skill_fields(oss)
    [oss.skill_description, oss.sort_order]
  end

  def generate_download_docs
    GenerateOccupationStandardPdfJob.perform_later(id)
    GenerateOccupationStandardExcelJob.perform_later(id)
  end

  def to_s
    "#{title} (#{organization.title})"
  end
end
