class CreateIndustries < ActiveRecord::Migration[6.0]
  def change
    create_table :industries do |t|
      t.string :title
      t.string :naics_code

      t.timestamps
    end
  end
end
