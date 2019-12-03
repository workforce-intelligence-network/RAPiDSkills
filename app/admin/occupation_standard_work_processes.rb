ActiveAdmin.register OccupationStandardWorkProcess do
  menu parent: 'OccupationStandards', label: 'WorkProcesses'

  includes :occupation_standard, :work_process

  permit_params :sort_order, :hours

  preserve_default_filters!
  remove_filter :occupation_standard_skills

  index do
    column :id
    column :occupation_standard
    column :work_process
    column :hours
    column :sort_order
    column :skills_count do |oswp|
      oswp.skills.count
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :occupation_standard
      row :work_process
      row :hours
      row :sort_order
      row :skills do |oswp|
        oswp.occupation_standard_skills.includes(:skill).map{|oss| link_to(oss.skill.description, admin_occupation_standard_skill_path(oss)) }.join(", ").html_safe
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :hours
      f.input :sort_order
    end
    f.actions
  end
end
