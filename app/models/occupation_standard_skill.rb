class OccupationStandardSkill < ApplicationRecord
  belongs_to :occupation_standard
  belongs_to :skill

  validates :occupation_standard, uniqueness: { scope: :skill }

  def to_s
    "#{occupation_standard.to_s}: #{skill.to_s}"
  end
end
