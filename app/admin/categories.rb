ActiveAdmin.register Category do
  permit_params :name, :occupation_standard_work_process_id, :sort_order
end
