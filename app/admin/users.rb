ActiveAdmin.register User do
  permit_params :email, :name, :role, :password, :password_confirmation, :employer_id

  filter :role
  filter :name
  filter :email
  filter :employer, collection: proc { Organization.order(:title) }
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  action_item :change_password, only: [:edit, :show] do
    link_to 'Change Password', change_password_admin_user_path(user)
  end

  action_item :invite, only: [:edit, :show] do
    link_to 'Invite', invite_admin_user_path(user) unless user.joined?
  end

  member_action :change_password, method: [:get, :put] do
    if request.put?
      password_params = params.require(:user).permit(:password, :password_confirmation)
      if resource.update_attributes(password_params)
        flash[:success] = "You have changed the password for #{resource.email}."
        redirect_to admin_user_path(resource)
      end
    end
  end

  member_action :invite, only: [:post] do
    UserMailer.with(user: resource).invite.deliver_later
    flash[:success] = "Invite sent to #{resource.email}."
    redirect_to admin_user_path(resource)
  end

  index do
    selectable_column
    id_column
    column :name
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :email
      f.input :role, include_blank: false
      f.input :employer
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

end
