class AddIndexOnTitleRapidsOnetForOccupations < ActiveRecord::Migration[6.0]
  def change
    add_index :occupations, [:title, :rapids_code, :onet_code], unique: true
  end
end
