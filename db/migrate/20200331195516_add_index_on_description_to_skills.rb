class AddIndexOnDescriptionToSkills < ActiveRecord::Migration[6.0]
  def change
    add_index :skills, :description
  end
end
