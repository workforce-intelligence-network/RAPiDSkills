class Occupation < ApplicationRecord
  searchkick

  validates :type, presence: true
  validates :title, uniqueness: { scope: [:rapids_code, :onet_code] }

  belongs_to :industry, optional: true
  has_many :occupation_standards

  scope :search_import, -> { includes(:industry) }

  class << self
    def search_records(args={})
      q = args[:q]
      return all if q.blank?
      search(q, operator: "or")
    end
  end

  def search_data
    {
      title: title,
      title_aliases: title_aliases,
      onet_code: onet_code,
      rapids_code: rapids_code,
      industry_naics_code: industry&.naics_code,
      industry_title: industry&.title,
    }
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
