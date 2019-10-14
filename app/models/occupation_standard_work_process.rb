class OccupationStandardWorkProcess < ApplicationRecord
  belongs_to :occupation_standard
  belongs_to :work_process

  validates :occupation_standard, uniqueness: { scope: :work_process }
  validates :hours, presence: true

  def to_s
    "#{occupation_standard.to_s}: #{work_process.to_s}"
  end
end
