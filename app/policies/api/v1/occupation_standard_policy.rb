class API::V1::OccupationStandardPolicy < ApplicationPolicy
  attr_reader :user, :os

  def initialize(user, os)
    @user = user
    @os = os
  end

  def destroy?
    os.creator == user
  end
end
