ActiveAdmin.register DataImport do
  permit_params :description, :kind, :file

  index do
    column :id
    column :kind
    column :description
    column :file do |data_import|
      data_import.file.filename
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :file do |data_import|
        link_to data_import.file.filename, url_for(data_import.file)
      end
      row :kind
      row :description
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :file, as: :file
      f.input :kind
      f.input :description
    end
    f.actions
  end
end