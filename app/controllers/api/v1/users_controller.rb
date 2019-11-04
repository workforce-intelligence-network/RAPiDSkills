class API::V1::UsersController < ApplicationController
  def create
    @user = User.where(
      email: params[:data][:attributes][:email]
    ).first_or_initialize(password: SecureRandom.uuid) # tmp pw for now
    @user.update(user_params) if @user.new_record?
    render json: API::V1::UserSerializer.new(@user)
  end

  private

  def user_params
    params.require(:data).require(:attributes).permit(:email, :name)
  end
end
