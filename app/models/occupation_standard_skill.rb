class OccupationStandardSkill < ApplicationRecord
  belongs_to :occupation_standard, touch: true
  belongs_to :skill
  belongs_to :occupation_standard_work_process, optional: true
  belongs_to :category, optional: true
  has_one :work_process, through: :occupation_standard_work_process

  validates :occupation_standard, uniqueness: { scope: [:skill, :occupation_standard_work_process] }

  delegate :description, to: :skill, prefix: true
  delegate :creator, to: :occupation_standard

  class << self
    def search_records(q:)
      if q.blank?
        skills = Skill.all
      else
        skills = Skill.search(q, operator: "or")
      end
      OccupationStandardSkill
        .select("DISTINCT ON(skills.description) occupation_standard_skills.id, skills.description")
        .joins(:skill)
        .where(skill: skills.to_a)
        .order("skills.description, occupation_standard_skills.id")
    end
  end

  def to_s
    "#{occupation_standard.to_s}: #{skill.to_s}"
  end
end
