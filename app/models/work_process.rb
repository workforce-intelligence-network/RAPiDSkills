class WorkProcess < ApplicationRecord
  has_many :skills
  has_many :occupation_standard_work_processes
  has_many :occupation_standards, through: :occupation_standard_work_processes

  validates :title, :description, presence: true

  def to_s
    title
  end
end
