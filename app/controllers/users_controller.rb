class UsersController < ApplicationController
  def new
  end

  def create
    @user = User.where(
      email: params[:user][:email]
    ).first_or_initialize(password: SecureRandom.uuid) # tmp pw for now
    @user.update(user_params) if @user.new_record?
    render :new
  end

  private

  def user_params
    params.require(:user).permit(:email, :name)
  end
end
