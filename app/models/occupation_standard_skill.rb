class OccupationStandardSkill < ApplicationRecord
  belongs_to :occupation_standard, touch: true
  belongs_to :skill
  belongs_to :occupation_standard_work_process, optional: true
  has_one :work_process, through: :occupation_standard_work_process

  validates :occupation_standard, uniqueness: { scope: [:skill, :occupation_standard_work_process] }

  delegate :description, to: :skill, prefix: true
  delegate :creator, to: :occupation_standard

  def to_s
    "#{occupation_standard.to_s}: #{skill.to_s}"
  end
end
