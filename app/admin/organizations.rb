ActiveAdmin.register Organization do
  permit_params :type, :title, :logo_url, :registers_standards
end
