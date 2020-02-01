class API::V1::OccupationStandardWorkProcessPolicy < ApplicationPolicy
  attr_reader :user, :oswp

  def initialize(user, oswp)
    @user = user
    @oswp = oswp
  end

  def update?
    oswp.creator == user
  end
end
