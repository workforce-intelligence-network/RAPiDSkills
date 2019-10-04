ActiveAdmin.register DataImport do
  permit_params :description, :kind, :file, :creator_id, :creator_type

  index do
    column :id
    column :creator
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
      row :creator
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    para "Do not modify headers of files for CSV imports", class: "info"
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :file, as: :file
      f.input :creator_type, as: :select, collection: %w(AdminUser User), include_blank: false
      f.input :creator_id, as: :select, collection: AdminUser.order(:email), input_html: { id: "data_import_creator_id_admin_user" }, wrapper_html: { class: "polymorphic", id: "data_import_creator_id_input_AdminUser" }
      f.input :creator_id, as: :select, collection: User.order(:name), input_html: { id: "data_import_creator_id_user", disabled: true }, wrapper_html: { class: "polymorphic hide", id: "data_import_creator_id_input_User" }
      f.input :kind
      f.input :description
    end
    f.actions
  end
end
