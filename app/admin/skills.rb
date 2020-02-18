ActiveAdmin.register Skill do
  includes :parent_skill

  permit_params :description, :usage_count, :parent_skill_id

  preserve_default_filters!
  remove_filter :occupation_standard_skills
  remove_filter :occupation_standards

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :description
      f.input :usage_count
      f.input :parent_skill
    end
    f.actions
  end
end
