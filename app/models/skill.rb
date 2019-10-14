class Skill < ApplicationRecord
  belongs_to :work_process, optional: true
  belongs_to :parent_skill, class_name: 'Skill', optional: true
  has_many :occupation_standard_skills
  has_many :occupation_standards, through: :occupation_standard_skills

  validates :description, presence: true

  def to_s
    description
  end
end
