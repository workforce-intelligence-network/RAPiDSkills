class OccupationStandardWorkProcess < ApplicationRecord
  belongs_to :occupation_standard, touch: true
  belongs_to :work_process
  has_many :occupation_standard_skills, -> { includes(:skill).where(category: nil).order(:sort_order) }
  has_many :categories, -> { includes(:occupation_standard_skills).order(:sort_order).group("categories.id") }
  has_many :skills, through: :occupation_standard_skills

  validates :work_process, uniqueness: { scope: :occupation_standard }

  delegate :title, to: :work_process, prefix: true
  delegate :description, to: :work_process, prefix: true
  delegate :creator, to: :occupation_standard

  scope :with_eager_loading, -> { includes(:work_process, :occupation_standard_skills) }

  def to_s
    "#{occupation_standard.to_s}: #{work_process.to_s}"
  end
end
