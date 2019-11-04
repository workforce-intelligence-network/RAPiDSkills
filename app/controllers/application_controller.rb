class ApplicationController < ActionController::Base
  def authenticate_admin_user!
    redirect_to root_path unless current_user&.admin?
  end

  protected

  def after_sign_in_path_for(resource)
    resource.admin? ? admin_root_path : super
  end
end
