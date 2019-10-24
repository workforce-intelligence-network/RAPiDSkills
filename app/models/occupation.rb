class Occupation < ApplicationRecord
  validates :rapids_code, presence: true, uniqueness: true
  validates :type, presence: true
  has_many :occupation_standards
  has_many :industries, through: :occupation_standards

  class << self
    def search(q)
      return all if q.blank?

      Occupation
        .select("O.*")
        .from("occupations O
                 LEFT JOIN (SELECT
                              occupations.id,
                              UNNEST(title_aliases) AS str
                            FROM occupations) AS sub ON (O.id = sub.id)")
        .where("O.title ILIKE :q OR sub.str ILIKE :q", q: "%#{q}%")
    end
  end

  def title_aliases=(list)
    if list.is_a?(String)
      super list.split(/;\s+/)
    else
      super list
    end
  end
end
