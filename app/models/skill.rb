class Skill < ApplicationRecord
  searchkick

  belongs_to :parent_skill, class_name: 'Skill', optional: true
  has_many :occupation_standard_skills
  has_many :occupation_standards, through: :occupation_standard_skills

  validates :description, presence: true

  class << self
    def search_records(q:)
      return all if q.blank?
      search(q, operator: "or")
    end
  end

  def search_data
    { description: description }
  end

  def to_s
    description
  end
end
