class AddIndustryIdToOccupations < ActiveRecord::Migration[6.0]
  def change
    add_reference :occupations, :industry, foreign_key: true
  end
end
