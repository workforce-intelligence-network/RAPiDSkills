class Occupation < ApplicationRecord
  validates :type, presence: true
  validates :title, uniqueness: { scope: [:rapids_code, :onet_code] }

  has_many :occupation_standards
  has_many :industries, through: :occupation_standards

  class << self
    def search(args={})
      q = args[:q]
      return all if q.blank?

      terms = q.split(/\s+/)
      condition = "(occupations.title ILIKE :term OR sub.str ILIKE :term)"
      conditions = terms.inject([]) do |array, term|
        array << sanitize_sql_for_conditions([condition, term: "%#{term}%"])
      end
      condition_str = conditions.join(" OR ")

      Occupation
        .select("occupations.*")
        .from("occupations
                 LEFT JOIN
               (SELECT
                  occupations.id,
                  UNNEST(title_aliases) AS str
                FROM occupations) AS sub ON (occupations.id = sub.id)")
        .where(condition_str)
        .distinct
    end
  end

  def title_aliases=(list)
    if list.is_a?(String)
      super list.split(/;\s+/)
    else
      super list
    end
  end

  def kind
    self.class.name.underscore.gsub('_occupation','')
  end
end
