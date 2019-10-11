class OccupationStandardWorkProcess < ApplicationRecord
  belongs_to :occupation_standard
  belongs_to :work_process

  validates :occupation_standard, uniqueness: { scope: :work_process }
  validates :hours, presence: true
end
