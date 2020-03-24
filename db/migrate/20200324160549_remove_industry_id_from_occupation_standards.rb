class RemoveIndustryIdFromOccupationStandards < ActiveRecord::Migration[6.0]
  def change
    remove_reference :occupation_standards, :industry, foreign_key: true
  end
end
