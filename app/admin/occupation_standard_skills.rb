ActiveAdmin.register OccupationStandardSkill do
  menu parent: 'OccupationStandards', label: 'Skills'

  includes :occupation_standard, :skill, :work_process

  permit_params :sort_order

  preserve_default_filters!
  remove_filter :occupation_standard_work_process

  index do
    column :id
    column :occupation_standard
    column :skill
    column :work_process
    column :sort_order
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :occupation_standard
      row :skill
      row :sort_order
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :sort_order
    end
    f.actions
  end
end
