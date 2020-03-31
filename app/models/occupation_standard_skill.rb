class OccupationStandardSkill < ApplicationRecord
  belongs_to :occupation_standard, touch: true
  belongs_to :skill
  belongs_to :occupation_standard_work_process, optional: true
  belongs_to :category, optional: true
  has_one :work_process, through: :occupation_standard_work_process

  validates :occupation_standard, uniqueness: { scope: [:skill, :occupation_standard_work_process] }

  delegate :description, to: :skill, prefix: true
  delegate :creator, to: :occupation_standard

  # This method first collects the underlying skill records for the search term
  # provided, and then grabs the first occupation_standard_skill record that
  # matches each skill. The UNNEST statement keeps the order of the skills that
  # was returned from elasticsearch. Skills from unregistered standards are not
  # returned.
  class << self
    def search_records(q:)
      if q.blank?
        skills = Skill.all
      else
        skills = Skill.search(q, operator: "or")
      end
      OccupationStandardSkill
        .select("DISTINCT ON(t.ord) occupation_standard_skills.id, skills.description, occupation_standard_skills.skill_id")
        .joins(:skill)
        .joins(:occupation_standard)
        .joins("JOIN UNNEST('{#{skills.map(&:id).join(",")}}'::int[]) WITH ORDINALITY t(elem, ord) ON (skills.id = elem)")
        .where.not(occupation_standards: { type: "UnregisteredStandard" })
        .includes(:skill)
        .order("t.ord")
    end
  end

  def to_s
    "#{occupation_standard.to_s}: #{skill.to_s}"
  end
end
