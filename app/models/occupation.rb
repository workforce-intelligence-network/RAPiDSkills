class Occupation < ApplicationRecord
  searchkick

  validates :type, presence: true
  validates :title, uniqueness: { scope: [:rapids_code, :onet_code] }

  has_many :occupation_standards
  has_many :industries, through: :occupation_standards

  def search_data
    {
      title: title,
      title_aliases: title_aliases,
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
