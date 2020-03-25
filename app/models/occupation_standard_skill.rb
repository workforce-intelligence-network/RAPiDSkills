class OccupationStandardSkill < ApplicationRecord
  belongs_to :occupation_standard, touch: true
  belongs_to :skill
  belongs_to :occupation_standard_work_process, optional: true
  belongs_to :category, optional: true
  has_one :work_process, through: :occupation_standard_work_process

  validates :occupation_standard, uniqueness: { scope: [:skill, :occupation_standard_work_process] }

  delegate :description, to: :skill, prefix: true
  delegate :creator, to: :occupation_standard

  # In our implementation of the {json:api} spec, the skill resource is
  # actually an occupation_standard_skill object. So to return skill
  # descriptions to the front-end, we need to either (1) define a new resource
  # that returns the records from the skills table, or (2) return
  # occupation_standard_skill records so we are consistent with other
  # skill-related endpoints. This implementation is doing the latter. The
  # search_records method first collects the underlying skill records for the
  # search term provided, and then grabs the first occupation_standard_skill
  # record that matches each skill. The UNNEST statement keeps the order of the
  # skills that was returned from elasticsearch.
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
        .joins("JOIN UNNEST('{#{skills.map(&:id).join(",")}}'::int[]) WITH ORDINALITY t(elem, ord) ON (skills.id = elem)")
        .includes(:skill)
        .order("t.ord")
    end
  end

  def to_s
    "#{occupation_standard.to_s}: #{skill.to_s}"
  end
end
