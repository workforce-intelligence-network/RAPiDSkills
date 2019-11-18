ActiveAdmin.register OccupationStandard do
  menu parent: 'OccupationStandards'

  includes :organization, :occupation, :parent_occupation_standard, :creator

  permit_params :type, :organization_id, :creator_id, :occupation_id, :data_trust_approval, :parent_occupation_standard_id, :industry_id, :completed_at, :published_at, :source_file_url, :title, skill_ids: [], work_process_ids: []

  SUBMODELS = %w(FrameworkStandard RegisteredStandard GuidelineStandard UnregisteredStandard)

  preserve_default_filters!
  filter :type, as: :select, collection: SUBMODELS
  remove_filter :occupation_standard_skills
  remove_filter :occupation_standard_work_processes
  remove_filter :occupation_standard_skills_with_no_work_process
  remove_filter :pdf_attachment
  remove_filter :pdf_blob
  remove_filter :excel_attachment
  remove_filter :excel_blob

  action_item :clone_occupation_standard, only: :show do
    link_to 'Clone', clone_occupation_standard_admin_occupation_standard_path(occupation_standard)
  end

  action_item :generate_occupation_standard_pdf, only: :show do
    link_to 'Generate PDF', generate_pdf_admin_occupation_standard_path(occupation_standard), method: :post
  end

  action_item :generate_occupation_standard_excel, only: :show do
    link_to 'Generate Excel', generate_excel_admin_occupation_standard_path(occupation_standard), method: :post
  end

  member_action :clone_occupation_standard, method: [:get, :post] do
    if request.post?
      args = params.require(resource.type.underscore.to_sym).permit(:creator_id, :organization_id).to_h.symbolize_keys
      os = resource.clone_as_unregistered!(args)
      if os.persisted?
        redirect_to admin_occupation_standard_path(os)
      else
        render :clone_occupation_standard
      end
    end
  end

  member_action :generate_pdf, method: [:post] do
    GenerateOccupationStandardPdfJob.perform_later(resource.id)
    flash[:notice] = "PDF is being generated"
    redirect_to admin_occupation_standard_path(resource)
  end

  member_action :generate_excel, method: [:post] do
    GenerateOccupationStandardExcelJob.perform_later(resource.id)
    flash[:notice] = "CSV file is being generated"
    redirect_to admin_occupation_standard_path(resource)
  end

  index do
    selectable_column
    column :id
    column :type
    column :organization
    column :title
    column :creator
    column :occupation
    column :data_trust_approval
    column :parent_occupation_standard
    column :completed_at
    column :published_at
    column :created_at
    column :updated_at
    actions
  end

  show do |os|
    attributes_table do
      row :id
      row :type
      row :organization
      row :title
      row :creator
      row :occupation
      row :data_trust_approval
      row :parent_occupation_standard
      row :industry
      row :completed_at
      row :published_at
      row :pdf do |occupation_standard|
        if occupation_standard.pdf.attached?
          link_to occupation_standard.pdf.filename, url_for(occupation_standard.pdf)
        end
      end
      row :excel do |occupation_standard|
        if occupation_standard.excel.attached?
          link_to occupation_standard.excel.filename, url_for(occupation_standard.excel)
        end
      end
      row :source_file_url
      row :created_at
      row :updated_at

      panel "Work Processes" do
        columns do
          column do
            span "Title", class: "header"
          end
          column do
            span "Hours", class: "header"
          end
          column do
            span "Skills", class: "header"
          end
        end
        os.occupation_standard_work_processes.eager_load_associations.each do |oswp|
          columns do
            column do
              link_to oswp.work_process.to_s, admin_occupation_standard_work_process_path(oswp)
            end
            column do
              oswp.hours
            end
            column do
              oswp.skills.map do |skill|
                oss = os.occupation_standard_skills.where(skill: skill).first
                link_to skill.to_s, admin_occupation_standard_skill_path(oss)
              end.join(", ").html_safe
            end
          end
        end
      end

      panel "Skills with no associated work process" do
        columns do
          column do
            span "Description", class: "header"
          end
        end
        os.occupation_standard_skills_with_no_work_process.each do |oss|
          columns do
            column do
              link_to oss.skill.to_s, admin_occupation_standard_skill_path(oss)
            end
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :type, as: :select, collection: SUBMODELS, include_blank: false
      f.input :organization
      f.input :title
      f.input :creator
      f.input :occupation
      f.input :data_trust_approval
      f.input :parent_occupation_standard
      f.input :industry
      f.input :skills, include_blank: true
      f.input :work_processes, include_blank: true
      f.input :completed_at
      f.input :published_at
      f.input :excel_file_url
      f.input :source_file_url
    end
    f.actions
  end
end
