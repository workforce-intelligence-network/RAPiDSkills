ActiveAdmin.register Organization do
  permit_params :type, :title, :logo_url, :registers_standards

  show do
    attributes_table do
      row :id
      row :type
      row :title
      row :logo_url
      row :registers_standards
      row :locations
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
