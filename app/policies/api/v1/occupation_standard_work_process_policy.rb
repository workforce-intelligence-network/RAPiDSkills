class API::V1::OccupationStandardWorkProcessPolicy < ApplicationPolicy
  attr_reader :user, :oswp

  def initialize(user, oswp)
    @user = user
    @oswp = oswp
  end

  def update?
    owned_by_user?
  end

  def create_skill?
    owned_by_user?
  end

  private

  def owned_by_user?
    oswp.creator == user
  end
end
