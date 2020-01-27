class API::V1::UserPolicy < ApplicationPolicy
  attr_reader :user, :target_user

  def initialize(user, target_user)
    @user = user
    @target_user = target_user
  end

  def favorite?
    owned_by_user?
  end

  def occupation_standard?
    owned_by_user?
  end

  private

  def owned_by_user?
    user == target_user
  end
end
