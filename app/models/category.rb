class Category < ApplicationRecord
  belongs_to :occupation_standard_work_process
  has_many :occupation_standard_skills, -> { order(:sort_order) }

  validates :name, presence: true,
    uniqueness: { scope: :occupation_standard_work_process }

  delegate :creator, to: :occupation_standard_work_process
end
