class RemovePdfFileUrlFromOccupationStandards < ActiveRecord::Migration[6.0]
  def change

    remove_column :occupation_standards, :pdf_file_url, :string
  end
end
