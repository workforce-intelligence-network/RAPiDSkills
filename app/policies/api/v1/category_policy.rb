class API::V1::CategoryPolicy < ApplicationPolicy
  attr_reader :user, :category

  def initialize(user, category)
    @user = user
    @category = category
  end

  def update?
    owned_by_user?
  end

  def create_skill?
    owned_by_user?
  end

  private

  def owned_by_user?
    category.creator == user
  end
end
