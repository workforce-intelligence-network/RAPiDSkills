class CreateOccupations < ActiveRecord::Migration[6.0]
  def change
    create_table :occupations do |t|
      t.string :title
      t.string :type
      t.string :rapids_code, index: { unique: true }
      t.string :onet_code
      t.string :onet_page_url
      t.integer :term_length_min
      t.integer :term_length_max
      t.string :title_aliases, array: true, default: []

      t.timestamps
    end
  end
end
