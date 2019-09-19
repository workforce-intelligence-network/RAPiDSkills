class Occupation < ApplicationRecord
  def title_aliases=(list)
    if list.is_a?(String)
      super list.split(/,\s+/)
    else
      super list
    end
  end
end
