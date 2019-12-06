class AddRegistrationOrganizationNameToOccupationStandards < ActiveRecord::Migration[6.0]
  def change
    add_column :occupation_standards, :registration_organization_name, :string
  end
end
