ActiveAdmin.register OccupationStandardSkill do
  menu parent: 'OccupationStandards', label: 'Skills'

  includes :occupation_standard, :skill, :occupation_standard_work_process, :work_process

  permit_params :occupation_standard_id, :skill_id, :occupation_standard_work_process_id, :sort_order

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
      row :occupation_standard_work_process
      row :sort_order
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      if f.object.new_record?
        f.input :skill
        f.input :occupation_standard
      end
      f.input :occupation_standard_work_process, collection: OccupationStandardWorkProcess.eager_load_associations.includes(occupation_standard: [:occupation, :organization])
      f.input :sort_order
    end
    f.actions
  end
end
