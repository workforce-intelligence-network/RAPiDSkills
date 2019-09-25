ActiveAdmin.register WorkProcess do
  permit_params :title, :description, :hours, :occupation_standard_id
end
