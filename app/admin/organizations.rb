ActiveAdmin.register Organization do
  includes logo_attachment: :blob

  permit_params :type, :title, :registers_standards, :logo

  preserve_default_filters!
  remove_filter :logo_blob
  remove_filter :logo_attachment

  index do
    selectable_column
    column :id
    column :type
    column :title
    column :registers_standards
    actions
  end

  show do
    attributes_table do
      row :id
      row :type
      row :title
      row :registers_standards
      row :locations
      row :logo do |org|
        org.logo.attached? ? image_tag(url_for(org.logo)) : nil
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :type
      f.input :title
      f.input :registers_standards
      f.input :logo, as: :file
    end
    f.actions
  end
end
