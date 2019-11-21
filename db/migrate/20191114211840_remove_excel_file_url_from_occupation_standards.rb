class RemoveExcelFileUrlFromOccupationStandards < ActiveRecord::Migration[6.0]
  def change

    remove_column :occupation_standards, :excel_file_url, :string
  end
end
