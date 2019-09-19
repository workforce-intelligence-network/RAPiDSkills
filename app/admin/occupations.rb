ActiveAdmin.register Occupation do
  permit_params :title, :type, :rapids_code, :onet_code, :onet_page_url, :term_length_min, :term_length_max, :title_aliases

  index do
    column :id
    column :title
    column :type
    column :rapids_code
    column :onet_code
    column :onet_page_url
    column "Term Length" do |occupation|
      "#{occupation.term_length_min} - #{occupation.term_length_max}"
    end
    column "Aliases" do |occupation|
      occupation.title_aliases.join(", ")
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :title
      row :type
      row :rapids_code
      row :onet_code
      row :onet_page_url
      row "Term Length" do |occupation|
        "#{occupation.term_length_min} - #{occupation.term_length_max}"
      end
      row "Aliases" do |occupation|
        occupation.title_aliases
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :title
      f.input :type
      f.input :rapids_code
      f.input :onet_code
      f.input :onet_page_url
      f.input :term_length_min
      f.input :term_length_max
      f.input :title_aliases, input_html: { value: f.object.title_aliases.join(", ") }, label: "Aliases (separate with commas)"
    end
    f.actions
  end
end
