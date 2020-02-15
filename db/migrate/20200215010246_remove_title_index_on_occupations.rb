class RemoveTitleIndexOnOccupations < ActiveRecord::Migration[6.0]
  def change
    remove_index :occupations, :title
  end
end
