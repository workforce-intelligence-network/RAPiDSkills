ActiveAdmin.register OccupationStandardSkill do
  menu parent: 'OccupationStandards', label: 'Skills'

  includes :occupation_standard, :skill

  permit_params :sort_order

  index do
    column :id
    column :occupation_standard
    column :skill
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
