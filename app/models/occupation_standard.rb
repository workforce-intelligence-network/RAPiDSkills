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

  def to_s
    "#{occupation.title} (#{organization.title})"
  end
end
