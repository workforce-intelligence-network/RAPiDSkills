class OccupationStandardWorkProcess < ApplicationRecord
  belongs_to :occupation_standard
  belongs_to :work_process
  has_many :occupation_standard_skills
  has_many :skills, through: :occupation_standard_skills

  validates :occupation_standard, uniqueness: { scope: :work_process }
  validates :hours, presence: true

  delegate :title, to: :work_process, prefix: true
  delegate :description, to: :work_process, prefix: true

  scope :eager_load_associations, -> { includes(:work_process, :occupation_standard_skills, :skills) }

  def relationships_url(association)
    Rails.application.routes.url_helpers.send("relationships_#{association}_api_v1_work_process_url", self)
  end

  def related_url(association)
    Rails.application.routes.url_helpers.send("api_v1_work_process_#{association}_url", self)
  end

  def to_s
    "#{occupation_standard.to_s}: #{work_process.to_s}"
  end
end
