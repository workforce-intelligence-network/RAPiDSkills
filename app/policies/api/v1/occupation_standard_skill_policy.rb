class API::V1::OccupationStandardSkillPolicy < ApplicationPolicy
  attr_reader :user, :oss

  def initialize(user, oss)
    @user = user
    @oss = oss
  end

  def update?
    oss.creator == user
  end
end
