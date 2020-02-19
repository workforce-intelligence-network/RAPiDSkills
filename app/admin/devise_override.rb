ActiveAdmin::Devise::SessionsController.class_eval do
  def after_sign_out_path_for(resource_or_scope)
    "/signout"
  end
end
