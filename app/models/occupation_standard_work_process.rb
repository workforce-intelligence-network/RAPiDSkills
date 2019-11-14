class OccupationStandardWorkProcess < ApplicationRecord
  belongs_to :occupation_standard
  belongs_to :work_process
  has_many :occupation_standard_skills
  has_many :skills, through: :occupation_standard_skills

  validates :occupation_standard, uniqueness: { scope: :work_process }
  validates :hours, presence: true

  delegate :title, to: :work_process, prefix: true
  delegate :description, to: :work_process, prefix: true

  def to_s
    "#{occupation_standard.to_s}: #{work_process.to_s}"
  end
end
