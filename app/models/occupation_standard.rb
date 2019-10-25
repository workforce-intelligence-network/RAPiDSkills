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

  validates :title, presence: true

  delegate :title, to: :organization, prefix: true
  delegate :title, to: :occupation, prefix: true
  delegate :title, to: :industry, prefix: true
  delegate :name, to: :creator, prefix: true

  class << self
    def filter_collection(options={})
      options.delete_if { |k, v| v != false && v.blank? }
      options.delete_if { |k, v| v.kind_of?(Array) and v.reject(&:blank?).empty? }
      options.inject(all) do |scope, (key, value)|
        case key.to_s
        when "occupation_id"
          scope.where("#{key}": value)
        else
          scope
        end
      end
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

  def to_s
    "#{title} (#{organization.title})"
  end
end
