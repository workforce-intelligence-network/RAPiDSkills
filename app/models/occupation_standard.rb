class OccupationStandard < ApplicationRecord
  belongs_to :organization
  belongs_to :occupation
  belongs_to :industry, optional: true
  belongs_to :creator, class_name: 'User'
  belongs_to :parent_occupation_standard, class_name: 'OccupationStandard', optional: true
  has_many :occupation_standard_skills
  has_many :skills, through: :occupation_standard_skills
  has_many :occupation_standard_work_processes
  has_many :work_processes, through: :occupation_standard_work_processes
  has_many :standards_registrations

  validates :title, presence: true

  def unregistered_clone(user_id:, organization_id:)
    os = UnregisteredStandard.create(
      creator_id: user_id,
      organization_id: organization_id,
      occupation: occupation,
      title: title,
      parent_occupation_standard: self,
    )

    os.occupation_standard_work_processes = occupation_standard_work_processes.map(&:dup)
    os.occupation_standard_skills = occupation_standard_skills.map(&:dup)

    os
  end

  def to_s
    "#{title} (#{organization.title})"
  end
end
