ActiveAdmin.register Location do
  includes :organization, :state

  permit_params :organization_id, :state_id, :street_address, :city, :zip_code
end
