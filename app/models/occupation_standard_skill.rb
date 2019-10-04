class OccupationStandardSkill < ApplicationRecord
  belongs_to :occupation_standard
  belongs_to :skill

  validates :occupation_standard, uniqueness: { scope: :skill }
end
