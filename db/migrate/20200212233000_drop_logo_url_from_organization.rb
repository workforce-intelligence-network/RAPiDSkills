class DropLogoUrlFromOrganization < ActiveRecord::Migration[6.0]
  def change
    remove_column :organizations, :logo_url
  end
end
