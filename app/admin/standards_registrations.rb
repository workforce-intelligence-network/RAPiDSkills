ActiveAdmin.register StandardsRegistration do
  includes :occupation_standard, :organization, :state

  permit_params :occupation_standard_id, :organization_id, :state_id
end
