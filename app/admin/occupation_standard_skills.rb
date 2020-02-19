ActiveAdmin.register OccupationStandardSkill do
  menu parent: 'OccupationStandards', label: 'Skills'

  includes :occupation_standard, :skill, :occupation_standard_work_process, :work_process

  permit_params :occupation_standard_id, :skill_id, :occupation_standard_work_process_id, :sort_order

  preserve_default_filters!
  filter :occupation_standard, collection: proc { OccupationStandard.order(:title) }
  filter :skill, collection: proc { Skill.order(:description) }
  filter :work_process, collection: proc { WorkProcess.order(:title) }
  remove_filter :occupation_standard_work_process

  controller do
    after_action :generate_download_docs, only: [:create, :update, :destroy]

    private

    def generate_download_docs
      resource.occupation_standard.generate_download_docs
    end
  end

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
      f.input :occupation_standard_work_process, collection: OccupationStandardWorkProcess.includes(:work_process, occupation_standard: [:occupation, :organization])
      f.input :sort_order
    end
    f.actions
  end
end
