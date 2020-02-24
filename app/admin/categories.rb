ActiveAdmin.register Category do
  includes :occupation_standard_skills, occupation_standard_work_process: [:work_process, occupation_standard: :organization]

  permit_params :name, :occupation_standard_work_process_id, :sort_order

  preserve_default_filters!
  remove_filter :occupation_standard_skills
  remove_filter :occupation_standard_work_process

  show do |category|
    attributes_table do
      row :id
      row :name
      row :occupation_standard_work_process
      row :sort_order
      row :skills do |category|
        category.occupation_standard_skills.includes(:skill).map{|oss| link_to(oss.skill.description, admin_occupation_standard_skill_path(oss)) }.join(", ").html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
