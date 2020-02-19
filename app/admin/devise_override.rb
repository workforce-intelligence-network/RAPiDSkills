ActiveAdmin::Devise::SessionsController.class_eval do
  def after_sign_out_path_for(resource_or_scope)
    if Rails.env.development?
      new_user_session_path
    else
      "/signout"
    end
  end
end
