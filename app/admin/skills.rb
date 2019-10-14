ActiveAdmin.register Skill do
  includes :work_process, :parent_skill

  permit_params :description, :usage_count, :work_process_id, :parent_skill_id

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :description
      f.input :usage_count
      f.input :work_process
      f.input :parent_skill
    end
    f.actions
  end
end
