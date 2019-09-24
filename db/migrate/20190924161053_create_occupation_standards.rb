class CreateOccupationStandards < ActiveRecord::Migration[6.0]
  def change
    create_table :occupation_standards do |t|
      t.string :type
      t.references :organization, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.references :occupation, null: false, foreign_key: true
      t.boolean :data_trust_approval
      t.references :parent_occupation_standard, foreign_key: { to_table: :occupation_standards }
      t.references :industry, foreign_key: true
      t.timestamp :completed_at
      t.timestamp :published_at
      t.string :pdf_file_url
      t.string :excel_file_url
      t.string :source_file_url

      t.timestamps
    end
  end
end
