class CreateOrganizations < ActiveRecord::Migration[6.0]
  def change
    create_table :organizations do |t|
      t.string :type
      t.string :title
      t.string :logo_url
      t.boolean :registers_standards

      t.timestamps
    end
  end
end
