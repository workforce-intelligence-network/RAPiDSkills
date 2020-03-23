class Industry < ApplicationRecord
  searchkick

  def search_data
    {
      naics_code: naics_code,
      title: title,
    }
  end
end
