ActiveAdmin.register Organization do
  includes logo_attachment: :blob

  permit_params :type, :title, :logo_url, :registers_standards, :logo

  show do
    attributes_table do
      row :id
      row :type
      row :title
      row :logo_url
      row :registers_standards
      row :locations
      row :logo do |org|
        image_tag url_for(org.logo)
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :id
      f.input :type
      f.input :title
      f.input :logo_url
      f.input :registers_standards
      f.input :logo, as: :file
    end
    f.actions
  end
end
