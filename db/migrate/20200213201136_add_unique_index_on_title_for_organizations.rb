class AddUniqueIndexOnTitleForOrganizations < ActiveRecord::Migration[6.0]
  def change
    add_index :organizations, :title, unique: true
  end
end
