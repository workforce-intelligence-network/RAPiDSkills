class RemoveRapidsCodeUniqueIndexFromOccupations < ActiveRecord::Migration[6.0]
  def up
    remove_index :occupations, :rapids_code
  end

  def down
    add_index :occupations, :rapids_code, unique: true
  end
end
