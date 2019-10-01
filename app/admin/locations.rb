ActiveAdmin.register Location do
  permit_params :organization_id, :state_id, :street_address, :city, :zip_code
end
