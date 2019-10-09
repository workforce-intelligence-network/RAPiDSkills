class ApplicationController < ActionController::Base
  def authenticate_admin_user!
    redirect_to root_path unless current_user&.admin?
  end
end
