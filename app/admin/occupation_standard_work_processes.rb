ActiveAdmin.register OccupationStandardWorkProcess do
  menu parent: 'OccupationStandards', label: 'WorkProcesses'

  includes :occupation_standard, :work_process

  permit_params :sort_order, :hours

  index do
    column :id
    column :occupation_standard
    column :work_process
    column :hours
    column :sort_order
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
