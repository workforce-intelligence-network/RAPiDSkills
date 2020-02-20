ActiveAdmin.register Category do
  includes :occupation_standard_skills, occupation_standard_work_process: [:work_process, occupation_standard: :organization]

  permit_params :name, :occupation_standard_work_process_id, :sort_order

  preserve_default_filters!
  remove_filter :occupation_standard_skills
  remove_filter :occupation_standard_work_process
end
