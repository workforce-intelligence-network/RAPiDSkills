ActiveAdmin.register DataImport do
  includes :user, file_attachment: :blob

  permit_params :description, :kind, :file, :user_id

  preserve_default_filters!
  remove_filter :file_blob

  index do
    column :id
    column :user
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
      row :user
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
      f.input :user
      f.input :kind
      f.input :description
    end
    f.actions
  end

  controller do
    def create
      @data_import = DataImport.new(permitted_params[:data_import])
      if @data_import.valid?
        @data_import.run_import
        if @data_import.all_sections_invalid
          render :new
        else
          if @data_import.errors.any?
            error_msg = "<div>File successfully imported except for the following errors:</div>"
            error_msg += "<div>" + @data_import.errors.full_messages.join("</div><div>") + "</div>"
            flash[:notice] = error_msg
            @data_import.errors.clear
          end
          @data_import.save
          redirect_to admin_data_import_path(@data_import)
        end
      else
        render :new
      end
    end
  end
end
