class AddIndexToOccupationTitle < ActiveRecord::Migration[6.0]
  def change
    add_index :occupations, :title
  end
end
