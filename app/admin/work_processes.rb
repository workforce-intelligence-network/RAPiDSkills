ActiveAdmin.register WorkProcess do
  permit_params :title, :description

  preserve_default_filters!
  remove_filter :occupation_standard_work_processes
  remove_filter :occupation_standards
end
